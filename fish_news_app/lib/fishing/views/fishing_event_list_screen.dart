// lib/fishing/views/fishing_event_list_screen.dart

import 'package:fish_news_app/components/app_error.dart';
import 'package:fish_news_app/components/app_loading.dart';
import 'package:fish_news_app/components/fishing_event_list_row.dart';
import 'package:fish_news_app/components/date_picker_field.dart';
import 'package:fish_news_app/fishing/models/fishing_event_model.dart';
import 'package:fish_news_app/fishing/view_models/fishing_event_view_model.dart';
import 'package:fish_news_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FishingEventListScreen extends StatefulWidget {
  const FishingEventListScreen({super.key});

  @override
  FishingEventListScreenState createState() => FishingEventListScreenState();
}

class FishingEventListScreenState extends State<FishingEventListScreen> {
  final TextEditingController _vesselIdController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late FishingEventViewModel _fishingEventViewModel;

  @override
  void initState() {
    super.initState();
    _fishingEventViewModel = FishingEventViewModel();
  }

  @override
  void dispose() {
    _vesselIdController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _fishingEventViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FishingEventViewModel>.value(
      value: _fishingEventViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fishing Events List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Vessel ID input
              TextField(
                controller: _vesselIdController,
                decoration: const InputDecoration(
                  labelText: 'Vessel ID',
                ),
              ),
              // Start Date Picker Field
              DatePickerField(
                controller: _startDateController,
                labelText: 'Start Date (YYYY-MM-DD)',
                firstDate: DateTime(2000),
                lastDate: _selectedEndDate ?? DateTime.now(),
                initialDate: _selectedStartDate,
                onDateSelected: (DateTime date) {
                  setState(() {
                    _selectedStartDate = date;
                  });
                },
                key: const Key('startDateField'),
              ),
              // End Date Picker Field
              DatePickerField(
                controller: _endDateController,
                labelText: 'End Date (YYYY-MM-DD)',
                firstDate: _selectedStartDate ?? DateTime(2000),
                lastDate: DateTime.now(),
                initialDate: _selectedEndDate,
                onDateSelected: (DateTime date) {
                  setState(() {
                    _selectedEndDate = date;
                  });
                },
                key: const Key('endDateField'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Fetch data when the button is pressed
                  String vesselId = _vesselIdController.text.trim();
                  String startDate = _startDateController.text.trim();
                  String endDate = _endDateController.text.trim();

                  // Input validation
                  if (vesselId.isEmpty || startDate.isEmpty || endDate.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  // Ensure start date is before end date
                  if (_selectedStartDate != null &&
                      _selectedEndDate != null &&
                      _selectedStartDate!.isAfter(_selectedEndDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Start date must be before end date')),
                    );
                    return;
                  }

                  // Fetch data
                  _fishingEventViewModel.fetchFishingEvents(
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
                    } else if (fishingEventViewModel
                        .fishingError.message.isNotEmpty) {
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
