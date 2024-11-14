import 'package:fish_news_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fish News App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                NavigationUtils.navigateToVesselList(context);
              },
              child: const Text('View Vessels'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                NavigationUtils.navigateToFishingEventList(context);
              },
              child: const Text('View Fishing Events'),
            ),
          ],
        ),
      ),
    );
  }
}
