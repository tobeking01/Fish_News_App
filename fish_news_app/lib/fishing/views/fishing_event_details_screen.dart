import 'package:fish_news_app/fishing/models/fishing_event_model.dart';
import 'package:flutter/material.dart';

class FishingEventDetailsScreen extends StatelessWidget {
  final FishingEvent fishingEvent;

  const FishingEventDetailsScreen({super.key, required this.fishingEvent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fishing Event ${fishingEvent.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Event ID: ${fishingEvent.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Type: ${fishingEvent.type}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Start: ${fishingEvent.start}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('End: ${fishingEvent.end}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Latitude: ${fishingEvent.latitude}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Longitude: ${fishingEvent.longitude}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Distance from Shore: ${fishingEvent.distanceFromShore} km', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Distance from Port: ${fishingEvent.distanceFromPort} km', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
