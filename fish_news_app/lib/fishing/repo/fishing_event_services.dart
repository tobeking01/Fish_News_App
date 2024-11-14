// lib/fishing/repo/fishing_event_services.dart

import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import 'base_service.dart';
import '../models/fishing_event_model.dart';

class FishingEventServices extends BaseService {
  Future<Object> fetchFishingEvents({
    required String vesselId,
    required String startDate,
    required String endDate,
    required String dataset,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Manually construct the query parameters with proper encoding
      final Map<String, String> queryParams = <String, String>{
        'vessels[0]': vesselId,
        'datasets[0]': dataset,
        'start-date': startDate,
        'end-date': endDate,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      // Manually build the query string with percent-encoding
      final String queryString = queryParams.entries.map((MapEntry<String, String> entry) {
        final String key = Uri.encodeQueryComponent(entry.key);
        final String value = Uri.encodeQueryComponent(entry.value);
        return '$key=$value';
      }).join('&');

      // Construct the full URL
      final String urlString = '${ApiConstants.baseUrl}/v3/events?$queryString';
final Uri url = Uri.parse(urlString);

      print('Request URL: $url');

      print('fetchFishingEvents called');
      final http.Response response = await getRequest(url);
      print('Request completed');
      print('API Response Body: ${response.body}');

      return handleResponse<FishingEvent>(
        response,
        (Map<String, dynamic> jsonData) {
          final List<FishingEvent> events = <FishingEvent>[];

          if (jsonData.containsKey('entries')) {
            final List<dynamic> entries = jsonData['entries'] as List<dynamic>;

            for (final dynamic entry in entries) {
              final Map<String, dynamic> entryMap = entry as Map<String, dynamic>;
              final FishingEvent event = FishingEvent.fromJson(entryMap);
              events.add(event);
            }
          }

          return events;
        },
      );
    } catch (e) {
      return handleError(e);
    }
  }
}