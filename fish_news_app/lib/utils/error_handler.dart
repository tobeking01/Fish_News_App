// lib/fishing/utils/error_handler.dart

import 'dart:io';

import 'package:fish_news_app/fishing/repo/api_status.dart';

class ErrorHandler {
  static ApiResponse<String> handleError(Object error) {
    if (error is HttpException) {
      return ApiResponse<String>.error("No Internet Response");
    } else if (error is SocketException) {
      return ApiResponse<String>.error("No Internet connection");
    } else if (error is FormatException) {
      return ApiResponse<String>.error("Invalid Format");
    } else {
      return ApiResponse<String>.error("Unknown Error: $error");
    }
  }
}
