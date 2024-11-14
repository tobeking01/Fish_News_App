// lib/utils/api_status.dart

enum ApiStatus {
  success,
  error,
  loading,
  empty,
}

class ApiResponse<T> {
  ApiStatus status;
  T? data;
  String? message;

  ApiResponse.loading([this.message]) : status = ApiStatus.loading;

  ApiResponse.success(this.data) : status = ApiStatus.success;

  ApiResponse.error([this.message]) : status = ApiStatus.error;

  ApiResponse.empty([this.message]) : status = ApiStatus.empty;
}