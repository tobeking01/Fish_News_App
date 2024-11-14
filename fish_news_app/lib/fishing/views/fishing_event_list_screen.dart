import 'package:fish_news_app/components/app_error.dart';
import 'package:fish_news_app/components/app_loading.dart';
import 'package:fish_news_app/components/fishing_event_list_row.dart';
import 'package:fish_news_app/components/date_picker_field.dart';
import 'package:fish_news_app/fishing/models/fishing_event_model.dart';
import 'package:fish_news_app/fishing/view_models/fishing_event_view_model.dart';
import 'package:fish_news_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FishingEventListScreen extends StatelessWidget {
  const FishingEventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // Check if the pop actually happened
        if (didPop) {
          // Clear fishing events after navigating back
          context.read<FishingEventViewModel>().clearFishingEvents();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fishing Events List'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // Manually load events from the database
                context.read<FishingEventViewModel>().loadFishingEventsFromDatabase();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Vessel ID input
              TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Vessel ID',
                ),
              ),
              // Start Date Picker Field
              DatePickerField(
                controller: TextEditingController(),
                labelText: 'Start Date (YYYY-MM-DD)',
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                onDateSelected: (DateTime date) {
                  // Date selection logic
                },
                key: const Key('startDateField'),
              ),
              // End Date Picker Field
              DatePickerField(
                controller: TextEditingController(),
                labelText: 'End Date (YYYY-MM-DD)',
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                onDateSelected: (DateTime date) {
                  // Date selection logic
                },
                key: const Key('endDateField'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Fetch data when the button is pressed
                  String vesselId = ''; // Replace with actual input
                  String startDate = ''; // Replace with actual input
                  String endDate = ''; // Replace with actual input

                  // Fetch data
                  context.read<FishingEventViewModel>().fetchFishingEvents(
                    vesselId: vesselId,
                    startDate: startDate,
                    endDate: endDate,
                  );
                },
                child: const Text('Fetch Fishing Events'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<FishingEventViewModel>(
                  builder: (BuildContext context,
                      FishingEventViewModel fishingEventViewModel,
                      Widget? child) {
                    if (fishingEventViewModel.isLoading) {
                      return const AppLoading();
                    } else if (fishingEventViewModel.fishingError.message.isNotEmpty) {
                      return AppError(
                        message: fishingEventViewModel.fishingError.message,
                      );
                    } else if (fishingEventViewModel.fishingEvents.isEmpty) {
                      return const Center(
                          child: Text('No fishing events available.'));
                    } else {
                      return ListView.builder(
                        itemCount: fishingEventViewModel.fishingEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final FishingEvent fishingEvent =
                              fishingEventViewModel.fishingEvents[index];
                          return FishingEventListRow(
                            fishingEvent: fishingEvent,
                            onTap: () {
                              NavigationUtils.navigateToFishingEventDetails(
                                  context, fishingEvent);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
