import 'package:fish_news_app/fishing/models/fishing_event_model.dart';
import 'package:fish_news_app/fishing/models/vessel_model.dart';
import 'package:fish_news_app/fishing/views/fishing_event_details_screen.dart';
import 'package:fish_news_app/fishing/views/fishing_event_list_screen.dart';
import 'package:fish_news_app/fishing/views/vessel_detail_screen.dart';
import 'package:fish_news_app/fishing/views/vessel_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fishing/view_models/vessel_view_model.dart';
import '../fishing/view_models/fishing_event_view_model.dart';

class NavigationUtils {
  static Future<void> navigateToVesselList(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeNotifierProvider<VesselViewModel>.value(
          value: context.read<VesselViewModel>(),
          child: const VesselListScreen(),
        ),
      ),
    );
  }

  static Future<void> navigateToFishingEventList(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeNotifierProvider<FishingEventViewModel>.value(
          value: context.read<FishingEventViewModel>(),
          child: const FishingEventListScreen(),
        ),
      ),
    );
  }

  static Future<void> navigateToVesselDetails(BuildContext context, Vessel vessel) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VesselDetailScreen(vessel: vessel),
      ),
    );
  }

  static Future<void> navigateToFishingEventDetails(BuildContext context, FishingEvent fishingEvent) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => FishingEventDetailsScreen(fishingEvent: fishingEvent),
      ),
    );
  }
}
