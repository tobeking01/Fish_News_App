import 'package:fish_news_app/fishing/models/vessel_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_news_app/fishing/view_models/vessel_view_model.dart';
import 'package:fish_news_app/components/vessel_list_row.dart';
import 'package:fish_news_app/components/app_loading.dart';
import 'package:fish_news_app/utils/navigation_utils.dart';

class VesselListScreen extends StatefulWidget {
  const VesselListScreen({super.key});

  @override
  State<VesselListScreen> createState() => _VesselListScreenState();
}

class _VesselListScreenState extends State<VesselListScreen> {
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _whereClauseController = TextEditingController();
  bool _useAdvancedSearch = false;

  // Hardcoded dataset, since only one is now allowed
  static const String dataset = 'public-global-vessel-identity:latest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vessels List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Toggle for basic or advanced search
            Row(
              children: <Widget>[
                const Text('Advanced Search'),
                Switch(
                  value: _useAdvancedSearch,
                  onChanged: (bool value) {
                    setState(() {
                      _useAdvancedSearch = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _useAdvancedSearch ? _whereClauseController : _queryController,
              decoration: InputDecoration(
                labelText: _useAdvancedSearch
                    ? 'Enter Advanced Where Clause'
                    : 'Enter IMO or Query (min 3 characters)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final String input = _useAdvancedSearch ? _whereClauseController.text : _queryController.text;
                    if (!_useAdvancedSearch && input.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Query must be at least 3 characters long.'),
                        ),
                      );
                    } else {
                      if (_useAdvancedSearch) {
                        context.read<VesselViewModel>().advancedFetchVessels(
                              whereClause: input,
                              dataset: dataset, // Using single, hardcoded dataset
                            );
                      } else {
                        context.read<VesselViewModel>().fetchVessels(
                              query: input,
                              dataset: dataset, // Using single, hardcoded dataset
                            );
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<VesselViewModel>(
                builder: (BuildContext context, VesselViewModel vesselViewModel, Widget? child) {
                  if (vesselViewModel.isLoading) {
                    return const AppLoading();
                  } else if (vesselViewModel.fishingError.message.isNotEmpty) {
                    return Center(
                      child: Text(
                        vesselViewModel.fishingError.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (vesselViewModel.vessels.isEmpty) {
                    return const Center(child: Text('No vessels available.'));
                  } else {
                    return ListView.builder(
                      itemCount: vesselViewModel.vessels.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Vessel vessel = vesselViewModel.vessels[index];
                        return VesselListRow(
                          vessel: vessel,
                          onTap: () {
                            NavigationUtils.navigateToVesselDetails(context, vessel);
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
    );
  }
}
