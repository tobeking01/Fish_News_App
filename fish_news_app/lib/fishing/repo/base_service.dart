import 'dart:convert';
import 'package:fish_news_app/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'api_status.dart';
import '../../utils/secrets.dart';

abstract class BaseService {
  // Method to make GET requests
  Future<http.Response> getRequest(Uri url) async {
    print('GET Request URL: $url'); // Log the URL

    return await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ${Secrets.apiKey}',
      },
    );
  }

  // Method to handle API responses
  Object handleResponse<T>(
    http.Response response,
    List<T> Function(Map<String, dynamic> jsonData) fromJsonList,
  ) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      final List<T> items = fromJsonList(jsonData);

      if (items.isNotEmpty) {
        return ApiResponse<List<T>>.success(items);
      } else {
        return ApiResponse<String>.error("No data found in response");
      }
    } else {
      // Try to parse the error message from the response
      String errorMessage = 'Invalid response from server: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorData = json.decode(response.body) as Map<String, dynamic>;

        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'] as String;
        } else if (errorData.containsKey('errors')) {
          final List<dynamic> errors = errorData['errors'] as List<dynamic>;
          if (errors.isNotEmpty && errors[0] is Map<String, dynamic>) {
            final Map<String, dynamic> firstError = errors[0] as Map<String, dynamic>;
            if (firstError.containsKey('message')) {
              errorMessage = firstError['message'] as String;
            }
          }
        }
      } catch (e) {
        // Parsing failed; use the default error message
      }

      print('API Error: $errorMessage');
      return ApiResponse<String>.error(errorMessage);
    }
  }

  // Error handling method
  ApiResponse<String> handleError(Object error) {
    print('An exception occurred: $error');
    return ErrorHandler.handleError(error);
  }
}
