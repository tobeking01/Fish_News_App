// lib/fishing/view_models/fishing_event_view_model.dart

import 'package:fish_news_app/fishing/repo/fishing_event_services.dart';
import 'package:flutter/material.dart';
import '../models/fishing_event_model.dart';
import '../models/fishing_error.dart';
import '../repo/api_status.dart';

class FishingEventViewModel extends ChangeNotifier {
  final FishingEventServices _fishingEventServices = FishingEventServices();

  List<FishingEvent> _fishingEvents = <FishingEvent>[];
  List<FishingEvent> get fishingEvents => _fishingEvents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FishingError _fishingError = FishingError(code: 0, message: '');
  FishingError get fishingError => _fishingError;

  // Default constructor
  FishingEventViewModel();

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setFishingEvents(List<FishingEvent> events) {
    _fishingEvents = events;
    print('Fishing events loaded: ${_fishingEvents.length}'); // Debug print

    notifyListeners();
  }

  void setFishingError(FishingError fishingError) {
    _fishingError = fishingError;
    notifyListeners();
  }

  Future<void> fetchFishingEvents({
    required String vesselId,
    required String startDate,
    required String endDate,
  }) async {
    setLoading(true);
    setFishingError(FishingError(code: 0, message: ''));

    final Object response = await _fishingEventServices.fetchFishingEvents(
      vesselId: vesselId,
      startDate: startDate,
      endDate: endDate,
      dataset: 'public-global-fishing-events:latest',
    );

    if (response is ApiResponse<List<FishingEvent>> &&
        response.status == ApiStatus.success) {
      setFishingEvents(response.data ?? <FishingEvent>[]);
    } else if (response is ApiResponse<String> &&
        response.status == ApiStatus.error) {
      print('API Error: ${response.message}');
      setFishingError(
          FishingError(code: 0, message: response.message ?? 'Unknown error'));
    }

    setLoading(false);
  }
}
