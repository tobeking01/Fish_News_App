import 'package:flutter/material.dart';
import 'package:fish_news_app/fishing/models/vessel_model.dart';

class VesselListRow extends StatelessWidget {
  final Vessel vessel;
  final VoidCallback onTap;

  const VesselListRow({super.key, required this.vessel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vessel.name.isNotEmpty ? vessel.name : 'Unnamed Vessel'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Shipname: ${vessel.shipname.isNotEmpty ? vessel.shipname : "N/A"}'),
          Text(
            'Flag: ${vessel.flag.isNotEmpty ? vessel.flag : "N/A"}, '
            'Length: ${vessel.length > 0 ? "${vessel.length}m" : "N/A"}',
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
