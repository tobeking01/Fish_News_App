// lib/components/fishing_event_list_row.dart
import 'package:flutter/material.dart';
import '../fishing/models/fishing_event_model.dart';

class FishingEventListRow extends StatelessWidget {
  final FishingEvent fishingEvent;
  final VoidCallback onTap;

  const FishingEventListRow({super.key, required this.fishingEvent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Event ID: ${fishingEvent.id}'),
      subtitle: Text('Type: ${fishingEvent.type}, Start: ${fishingEvent.start}'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
