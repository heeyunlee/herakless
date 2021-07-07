import 'package:cloud_firestore/cloud_firestore.dart';

class Measurement {
  final String measurementId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final num? bodyWeight;
  final num? bodyFat; // Nullable
  final num? skeletalMuscleMass; // Nullable
  final num? bmi; // Nullable
  final String? notes; // Nullables
  final String? dataSource; // Nullables
  final String? sourceId;
  final String? sourceName;
  final String? dataType;
  final String? platformType;

  const Measurement({
    required this.measurementId,
    required this.userId,
    required this.username,
    required this.loggedTime,
    required this.loggedDate,
    this.bodyWeight,
    this.bodyFat,
    this.skeletalMuscleMass,
    this.bmi,
    this.notes,
    this.dataSource,
    this.sourceId,
    this.sourceName,
    this.dataType,
    this.platformType,
  });

  factory Measurement.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'];
      final String username = data['username'];
      final Timestamp loggedTime = data['loggedTime'];
      final DateTime loggedDate = data['loggedDate'].toDate();
      final num? bodyWeight = data['bodyWeight'];
      final num? bodyFat = data['bodyFat'];
      final num? skeletalMuscleMass = data['skeletalMuscleMass'];
      final num? bmi = data['bmi'];
      final String? notes = data['notes'];
      final String? dataSource = data['dataSource'];
      final String? sourceId = data['sourceId'];
      final String? sourceName = data['sourceName'];
      final String? dataType = data['dataType'];
      final String? platformType = data['platformType'];

      return Measurement(
        measurementId: documentId,
        userId: userId,
        username: username,
        loggedTime: loggedTime,
        loggedDate: loggedDate,
        bodyWeight: bodyWeight,
        bodyFat: bodyFat,
        skeletalMuscleMass: skeletalMuscleMass,
        bmi: bmi,
        notes: notes,
        dataSource: dataSource,
        sourceId: sourceId,
        sourceName: sourceName,
        dataType: dataType,
        platformType: platformType,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'loggedTime': loggedTime,
      'loggedDate': loggedDate,
      'bodyWeight': bodyWeight,
      'bodyFat': bodyFat,
      'skeletalMuscleMass': skeletalMuscleMass,
      'bmi': bmi,
      'notes': notes,
      'dataSource': dataSource,
      'sourceId': sourceId,
      'sourceName': sourceName,
      'dataType': dataType,
      'platformType': platformType,
    };
  }

  Measurement copyWith({
    String? measurementId,
    String? userId,
    String? username,
    Timestamp? loggedTime,
    DateTime? loggedDate,
    num? bodyWeight,
    num? bodyFat,
    num? skeletalMuscleMass,
    num? bmi,
    String? notes,
    String? dataSource,
    String? sourceId,
    String? sourceName,
    String? dataType,
    String? platformType,
  }) {
    return Measurement(
      measurementId: measurementId ?? this.measurementId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      loggedTime: loggedTime ?? this.loggedTime,
      loggedDate: loggedDate ?? this.loggedDate,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      bodyFat: bodyFat ?? this.bodyFat,
      skeletalMuscleMass: skeletalMuscleMass ?? this.skeletalMuscleMass,
      bmi: bmi ?? this.bmi,
      notes: notes ?? this.notes,
      dataSource: dataSource ?? this.dataSource,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      dataType: dataType ?? this.dataType,
      platformType: platformType ?? this.platformType,
    );
  }
}

class LatestUserMeasurement {
  final String latestUserMeasurementId;
  final num? weight;
  final DateTime? latestWeightUpdateTime;
  final num? bodyFat;
  final DateTime? latestBodyFatUpdateTime;
  final num? skeletalMuscleMass;
  final DateTime? latestskeletalMuscleMassUpdateTime;
  final num? bmi;
  final DateTime? latestBmiUpdateTime;

  const LatestUserMeasurement({
    required this.latestUserMeasurementId,
    this.weight,
    this.latestWeightUpdateTime,
    this.bodyFat,
    this.latestBodyFatUpdateTime,
    this.skeletalMuscleMass,
    this.latestskeletalMuscleMassUpdateTime,
    this.bmi,
    this.latestBmiUpdateTime,
  });
}
