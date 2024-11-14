import 'package:flutter/material.dart';
import 'package:fish_news_app/fishing/models/vessel_model.dart';

class VesselDetailScreen extends StatelessWidget {
  final Vessel vessel;

  const VesselDetailScreen({super.key, required this.vessel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vessel.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                            Text('Shipname: ${vessel.shipname.isNotEmpty ? vessel.shipname : "N/A"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              Text('Vessel ID: ${vessel.id}'),
              Text('Flag: ${vessel.flag}'),
              Text('Callsign: ${vessel.callsign}'),
              Text('IMO: ${vessel.imo}'),
              Text('Length: ${vessel.length} meters'),
              Text('Tonnage: ${vessel.tonnage} GT'),
              Text('Gear Type: ${vessel.gearType}'),
              const SizedBox(height: 16),
              if (vessel.owners.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Owners:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...vessel.owners.map((Owner owner) => Text('- ${owner.name}')),
                  ],
                ),
              const SizedBox(height: 16),
              if (vessel.authorizations.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Authorizations:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...vessel.authorizations.map((Authorization auth) => Text('- ${auth.authorization}')),
                  ],
                ),
              const SizedBox(height: 16),
              if (vessel.matchCriteria.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Match Criteria:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...vessel.matchCriteria.map(
                      (MatchCriteria criteria) => Text(
                          '- ${criteria.property} matches ${criteria.matches.map((Match m) => m.value).join(', ')}'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
