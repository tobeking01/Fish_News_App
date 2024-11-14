// lib/utils/constants.dart

import 'secrets.dart';

class ApiConstants {
  static const String baseUrl = 'https://gateway.api.globalfishingwatch.org';
  static const String vesselSearchEndpoint = '/v3/vessels/search';
  static const String fishingEventsEndpoint = "/events";
  static const String apiKey = Secrets.apiKey;  // Use the API key from secrets.dart

  // Success and error codes
  static const int success = 200;

  // Error codes for application-specific issues
  static const int userInvalidResponse = 100;
  static const int noInternet = 101;
  static const int invalidFormat = 102;
  static const int unknownError = 103;
}
