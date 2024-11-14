import 'package:fish_news_app/sqDB/database_helper.dart';
import 'package:flutter/material.dart';
import '../repo/vessel_services.dart';
import '../models/vessel_model.dart';
import '../models/fishing_error.dart';
import '../repo/api_status.dart';

class VesselViewModel extends ChangeNotifier {
  final VesselServices _vesselServices = VesselServices();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Vessels list
  List<Vessel> _vessels = <Vessel>[];
  List<Vessel> get vessels => _vessels;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message
  FishingError _fishingError = FishingError(code: 0, message: '');
  FishingError get fishingError => _fishingError;

  // Constructor
  VesselViewModel();

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set vessels list with filtering for essential information
  void setVessels(List<Vessel> vessels) {
    _vessels = vessels.where((Vessel vessel) => vessel.name.isNotEmpty || vessel.flag.isNotEmpty).toList();
    notifyListeners();
  }

// Clear the vessels list
  void clearVessels() {
    _vessels = <Vessel>[];
    notifyListeners();
  }
  
  // Set error
  void setFishingError(FishingError fishingError) {
    _fishingError = fishingError;
    notifyListeners();
  }

  // Fetch vessels with basic query
  Future<void> fetchVessels({
    required String query,
    required String dataset, // Single dataset
  }) async {
    if (query.isEmpty || query.length < 3) {
      setFishingError(FishingError(
        code: 0,
        message: 'Query must be at least 3 characters long.',
      ));
      return;
    }

    setLoading(true);
    setFishingError(FishingError(code: 0, message: ''));

    final Object response = await _vesselServices.fetchVessels(
      query: query,
      dataset: dataset, // Single dataset
      includes: <String>['OWNERSHIP', 'AUTHORIZATIONS', 'MATCH_CRITERIA'],
    );

    if (response is ApiResponse<List<Vessel>> && response.status == ApiStatus.success) {
      setVessels(response.data ?? <Vessel>[]);
    } else if (response is ApiResponse<String> && response.status == ApiStatus.error) {
      setFishingError(
        FishingError(code: 0, message: response.message ?? 'Unknown error'),
      );
    }

    setLoading(false);
  }

  // Advanced fetch vessels method with where clause
  Future<void> advancedFetchVessels({
    required String whereClause,
    required String dataset, // Single dataset
  }) async {
    setLoading(true);
    setFishingError(FishingError(code: 0, message: ''));

    final Object response = await _vesselServices.fetchVessels(
      where: whereClause,
      dataset: dataset, // Single dataset
      includes: <String>['OWNERSHIP', 'AUTHORIZATIONS', 'MATCH_CRITERIA'],
    );

     if (response is ApiResponse<List<Vessel>> && response.status == ApiStatus.success) {
      setVessels(response.data ?? <Vessel>[]);

      // Save fetched vessels to the database
      for (final Vessel vessel in _vessels) {
        await _databaseHelper.insertVessel(vessel);
      }
    } else if (response is ApiResponse<String> && response.status == ApiStatus.error) {
      setFishingError(FishingError(code: 0, message: response.message ?? 'Unknown error'));
    }

    setLoading(false);
  }
// Load vessels from the database
  Future<void> loadVesselsFromDatabase() async {
    setLoading(true);
    _vessels = await _databaseHelper.getVessels();
    setLoading(false);
    notifyListeners();
  }

  // Add a vessel to the database
  Future<void> addVessel(Vessel vessel) async {
    await _databaseHelper.insertVessel(vessel);
    await loadVesselsFromDatabase(); // Refresh the list
  }
}
