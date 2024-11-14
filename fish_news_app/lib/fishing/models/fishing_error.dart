import 'dart:convert';

// Parses JSON string to FishingError
FishingError fishingErrorFromJson(String str) =>
    FishingError.fromJson(json.decode(str) as Map<String, dynamic>);

// Converts FishingError to JSON string
String fishingErrorToJson(FishingError data) => json.encode(data.toJson());

class FishingError {
  final int code;
  final String message;

  FishingError({
    this.code = 0,
    this.message = '',
  });

  // Empty constructor
  static FishingError empty() => FishingError();

  // Method to convert JSON data to a FishingError object
  factory FishingError.fromJson(Map<String, dynamic> json) {
    return FishingError(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? 'An unknown error occurred',
    );
  }

  // Method to convert FishingError object to JSON data
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'message': message,
      };
}
