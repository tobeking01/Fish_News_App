// lib/fishing/models/fishing_event_model.dart

class FishingEvent {
  final String id;
  final String type;
  final DateTime start;
  final DateTime end;
  final double latitude;
  final double longitude;
  final double distanceFromShore;
  final double distanceFromPort;
  final String vesselId;

  FishingEvent({
    this.id = '',
    this.type = '',
    DateTime? start,
    DateTime? end,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.distanceFromShore = 0.0,
    this.distanceFromPort = 0.0,
    this.vesselId = '',
  })  : start = start ?? DateTime.now(),
        end = end ?? DateTime.now();

  // Empty constructor
  static FishingEvent empty() => FishingEvent();

  // Method to convert JSON data to a FishingEvent object
  factory FishingEvent.fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String? ?? '';
    String type = json['type'] as String? ?? '';
    DateTime start = DateTime.tryParse(
            json['start'] as String? ?? DateTime.now().toIso8601String()) ??
        DateTime.now();
    DateTime end = DateTime.tryParse(
            json['end'] as String? ?? DateTime.now().toIso8601String()) ??
        DateTime.now();

    // Handle nested position data
    double latitude = 0.0;
    double longitude = 0.0;
    if (json['position'] != null && json['position'] is Map<String, dynamic>) {
      final Map<String, dynamic> position =
          json['position'] as Map<String, dynamic>;
      latitude = (position['lat'] as num?)?.toDouble() ?? 0.0;
      longitude = (position['lon'] as num?)?.toDouble() ?? 0.0;
    }

    // Handle nested distances data
    double distanceFromShore = 0.0;
    double distanceFromPort = 0.0;
    if (json['distances'] != null &&
        json['distances'] is Map<String, dynamic>) {
      final Map<String, dynamic> distances =
          json['distances'] as Map<String, dynamic>;
      distanceFromShore =
          (distances['endDistanceFromShoreKm'] as num?)?.toDouble() ?? 0.0;
      distanceFromPort =
          (distances['endDistanceFromPortKm'] as num?)?.toDouble() ?? 0.0;
    }

    String vesselId = '';
    if (json['vessel'] != null && json['vessel'] is Map<String, dynamic>) {
      final Map<String, dynamic> vessel =
          json['vessel'] as Map<String, dynamic>;
      vesselId = vessel['id'] as String? ?? '';
    }

    return FishingEvent(
      id: id,
      type: type,
      start: start,
      end: end,
      latitude: latitude,
      longitude: longitude,
      distanceFromShore: distanceFromShore,
      distanceFromPort: distanceFromPort,
      vesselId: vesselId,
    );
  }

  // Method to convert FishingEvent object to JSON data
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'position': <String, dynamic>{
          'lat': latitude,
          'lon': longitude,
        },
        'distances': <String, dynamic>{
          'endDistanceFromShoreKm': distanceFromShore,
          'endDistanceFromPortKm': distanceFromPort,
        },
        'vessel': <String, dynamic>{
          'id': vesselId,
        },
      };

  // Method to convert a Map to a FishingEvent object
  factory FishingEvent.fromMap(Map<String, dynamic> map) {
    return FishingEvent(
      id: map['id'] as String? ?? '',
      type: map['type'] as String? ?? '',
      start: DateTime.tryParse(map['start'] as String? ?? '') ?? DateTime.now(),
      end: DateTime.tryParse(map['end'] as String? ?? '') ?? DateTime.now(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceFromShore: (map['distanceFromShore'] as num?)?.toDouble() ?? 0.0,
      distanceFromPort: (map['distanceFromPort'] as num?)?.toDouble() ?? 0.0,
      vesselId: map['vesselId'] as String? ?? '',
    );
  }

// Method to convert FishingEvent object to a Map (for database operations)
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'type': type,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'distanceFromShore': distanceFromShore,
        'distanceFromPort': distanceFromPort,
        'vesselId': vesselId,
      };
}
