import 'dart:convert';

// Parses JSON string to a List<Vessel>
List<Vessel> vesselListFromJson(String str) =>
    List<Vessel>.from((json.decode(str) as List<dynamic>)
        .map((dynamic x) => Vessel.fromJson(x as Map<String, dynamic>)));

// Converts List<Vessel> to JSON string
String vesselListToJson(List<Vessel> data) => json.encode(
    List<Map<String, dynamic>>.from(data.map((Vessel x) => x.toJson())));

// Owner model
class Owner {
  final String name;
  final String flag;
  final String ssvid;
  final String sourceCode;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  Owner({
    required this.name,
    required this.flag,
    required this.ssvid,
    required this.sourceCode,
    this.dateFrom,
    this.dateTo,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      ssvid: json['ssvid'] as String? ?? '',
      sourceCode: (json['sourceCode'] as List<dynamic>?)?.join(', ') ?? '',
      dateFrom: json['dateFrom'] != null
          ? DateTime.parse(json['dateFrom'] as String)
          : null,
      dateTo: json['dateTo'] != null
          ? DateTime.parse(json['dateTo'] as String)
          : null,
    );
  }
}

// Authorization model
class Authorization {
  final String authorization;
  final String source;

  Authorization({
    required this.authorization,
    required this.source,
  });

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      authorization: json['authorization'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }
}

// MatchCriteria model
class MatchCriteria {
  final String reference;
  final String property;
  final String source;
  final List<Match> matches;
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool latestVesselInfo;

  MatchCriteria({
    required this.reference,
    required this.property,
    required this.source,
    required this.matches,
    required this.dateFrom,
    required this.dateTo,
    required this.latestVesselInfo,
  });

  factory MatchCriteria.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? periodData =
        json['period'] as Map<String, dynamic>?;

    return MatchCriteria(
      reference: json['reference'] as String? ?? '',
      property: json['property'] as String? ?? '',
      source: json['source'] as String? ?? '',
      matches: (json['matches'] as List<dynamic>?)
              ?.map((dynamic m) => Match.fromJson(m as Map<String, dynamic>))
              .toList() ??
          <Match>[],
      dateFrom: periodData != null && periodData['dateFrom'] is String
          ? DateTime.tryParse(periodData['dateFrom'] as String) ??
              DateTime.now()
          : DateTime.now(),
      dateTo: periodData != null && periodData['dateTo'] is String
          ? DateTime.tryParse(periodData['dateTo'] as String) ?? DateTime.now()
          : DateTime.now(),
      latestVesselInfo: json['latestVesselInfo'] as bool? ?? false,
    );
  }
}

// Match model used in MatchCriteria
class Match {
  final String property;
  final String value;

  Match({
    required this.property,
    required this.value,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      property: json['property'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

// Vessel class definition
class Vessel {
  final String id;
  final String name;
  final String shipname;
  final String flag;
  final String callsign;
  final String imo;
  final double length;
  final double tonnage;
  final String gearType;

  // New fields
  final List<Owner> owners;
  final List<Authorization> authorizations;
  final List<MatchCriteria> matchCriteria;

  Vessel({
    this.id = '',
    this.name = '',
    this.shipname = '',
    this.flag = '',
    this.callsign = '',
    this.imo = '',
    this.length = 0.0,
    this.tonnage = 0.0,
    this.gearType = 'Unknown',
    this.owners = const <Owner>[],
    this.authorizations = const <Authorization>[],
    this.matchCriteria = const <MatchCriteria>[],
  });

  // Empty constructor
  static Vessel empty() => Vessel();

  // Method to convert JSON data to a Vessel object
  factory Vessel.fromJson(Map<String, dynamic> json) {
    String gearType = 'Unknown';
    if (json['geartype'] != null &&
        json['geartype'] is List<dynamic> &&
        (json['geartype'] as List<dynamic>).isNotEmpty) {
      gearType = (json['geartype'] as List<dynamic>).join(', ');
    }

    // Extract and handle registryInfo data safely
    final List<Map<String, dynamic>> registryInfoList =
        (json['registryInfo'] as List<dynamic>?)
                ?.map((dynamic e) => e as Map<String, dynamic>)
                .toList() ??
            <Map<String, dynamic>>[];
    final Map<String, dynamic>? registryInfo =
        registryInfoList.isNotEmpty ? registryInfoList.first : null;

    String shipname = 'N/A';
    if (json['selfReportedInfo'] != null &&
        (json['selfReportedInfo'] as List<dynamic>).isNotEmpty) {
      final List<Map<String, dynamic>> selfReportedInfoList =
          (json['selfReportedInfo'] as List<dynamic>)
              .map((dynamic e) => e as Map<String, dynamic>)
              .toList();
      shipname = selfReportedInfoList.first['shipname'] ?? 'N/A';
    }

    return Vessel(
      id: registryInfo?['id'] as String? ?? '',
      name: registryInfo?['shipname'] as String? ?? '',
      shipname: shipname,
      flag: registryInfo?['flag'] as String? ?? 'N/A',
      callsign: registryInfo?['callsign'] as String? ?? 'N/A',
      imo: registryInfo?['imo'] as String? ?? 'N/A',
      length: (registryInfo?['lengthM'] as num?)?.toDouble() ?? 0.0,
      tonnage: (registryInfo?['tonnageGt'] as num?)?.toDouble() ?? 0.0,
      gearType: gearType,
      owners: (json['registryOwners'] as List<dynamic>?)
              ?.map((dynamic ownerInfo) =>
                  Owner.fromJson(ownerInfo as Map<String, dynamic>))
              .toList() ??
          <Owner>[],
      authorizations: (json['registryPublicAuthorizations'] as List<dynamic>?)
              ?.map((dynamic authInfo) =>
                  Authorization.fromJson(authInfo as Map<String, dynamic>))
              .toList() ??
          <Authorization>[],
      matchCriteria: (json['matchCriteria'] as List<dynamic>?)
              ?.map((dynamic matchInfo) =>
                  MatchCriteria.fromJson(matchInfo as Map<String, dynamic>))
              .toList() ??
          <MatchCriteria>[],
    );
  }

  // Method to convert Vessel object to JSON data
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'shipname': name,
        'flag': flag,
        'callsign': callsign,
        'imo': imo,
        'lengthM': length,
        'tonnageGt': tonnage,
        'geartype': gearType,
      };
}
