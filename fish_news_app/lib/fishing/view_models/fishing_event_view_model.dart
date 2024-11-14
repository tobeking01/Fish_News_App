import 'package:fish_news_app/fishing/repo/fishing_event_services.dart';
import 'package:fish_news_app/sqDB/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/fishing_event_model.dart';
import '../models/fishing_error.dart';
import '../repo/api_status.dart';

class FishingEventViewModel extends ChangeNotifier {
  final FishingEventServices _fishingEventServices = FishingEventServices();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<FishingEvent> _fishingEvents = <FishingEvent>[];
  List<FishingEvent> get fishingEvents => _fishingEvents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FishingError _fishingError = FishingError(code: 0, message: '');
  FishingError get fishingError => _fishingError;

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set the fishing events list
  void setFishingEvents(List<FishingEvent> events) {
    _fishingEvents = events;
    notifyListeners();
  }


    // Clear the fishing events list
  void clearFishingEvents() {
    _fishingEvents = <FishingEvent>[];
    notifyListeners();
  }
  
  // Set error
  void setFishingError(FishingError fishingError) {
    _fishingError = fishingError;
    notifyListeners();
  }

  // Fetch fishing events from the API and save them to the database
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

      // Save events to the database
      for (final FishingEvent event in _fishingEvents) {
        await _databaseHelper.insertFishingEvent(event);
      }
    } else if (response is ApiResponse<String> &&
        response.status == ApiStatus.error) {
      setFishingError(
        FishingError(code: 0, message: response.message ?? 'Unknown error'),
      );
    }

    setLoading(false);
  }

  // Load fishing events from the database
  Future<void> loadFishingEventsFromDatabase() async {
    setLoading(true);
    _fishingEvents = await _databaseHelper.getFishingEvents();
      // Debugging output
  print("Loaded ${_fishingEvents.length} fishing events into the view model.");
    setLoading(false);
    notifyListeners();
  }

  // Add a single fishing event to the database
  Future<void> addFishingEvent(FishingEvent event) async {
    await _databaseHelper.insertFishingEvent(event);
    print("Added Fishing Event with ID: ${event.id}"); // Debug log
    await loadFishingEventsFromDatabase(); // Refresh the list
  }

}
