// lib/fishing/repo/vessel_services.dart

import 'package:http/http.dart' as http;
import '../models/vessel_model.dart';
import '../../utils/constants.dart';
import 'base_service.dart';
import '../repo/api_status.dart';

class VesselServices extends BaseService {
  // Fetch vessels based on query or where clause and a single dataset
  Future<Object> fetchVessels({
    String? query,
    String? where,
    required String dataset, // Changed to a single dataset
    List<String>? includes,
  }) async {
    try {
      // Validate that either query or where is provided, but not both
      if ((query == null && where == null) || (query != null && where != null)) {
        return ApiResponse<String>.error(
          "Either 'query' or 'where' parameter must be provided, but not both.",
        );
      }

      // Construct query parameters
      final Map<String, String> queryParams = <String, String>{
        'datasets[0]': dataset, // Only one dataset
        if (query != null) 'query': query,
        if (where != null) 'where': where,
        if (includes != null)
          for (int i = 0; i < includes.length; i++) 'includes[$i]': includes[i],
      };

      // Manually construct the query string to avoid encoding brackets
      final String queryString = queryParams.entries.map((MapEntry<String, String> e) {
        final String key = e.key;
        final String value = Uri.encodeQueryComponent(e.value);
        return '$key=$value';
      }).join('&');

      // Construct the full URL
      final String urlString =
          '${ApiConstants.baseUrl}${ApiConstants.vesselSearchEndpoint}?$queryString';

      final Uri url = Uri.parse(urlString);
      print('Request URL: $url');

      final http.Response response = await getRequest(url);

      if (response.statusCode == 422) {
        // Print the response body for additional error details
        print('Server response: ${response.body}');
        return ApiResponse<String>.error('Invalid response from server: ${response.statusCode}');
      }

      return handleResponse<Vessel>(
        response,
        (Map<String, dynamic> jsonData) {
          final List<Vessel> vessels = <Vessel>[];

          if (jsonData.containsKey('entries')) {
            final List<dynamic> entries = jsonData['entries'] as List<dynamic>;

            for (final dynamic entry in entries) {
              final Map<String, dynamic> entryMap = entry as Map<String, dynamic>;

              // Pass the entire entry to Vessel.fromJson
              final Vessel vessel = Vessel.fromJson(entryMap);
              vessels.add(vessel);
            }
          }

          return vessels;
        },
      );
    } catch (e) {
      return handleError(e);
    }
  }
}
