// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:alagy/core/common/enities/user_model.dart';

class DoctorModel extends UserModel {
  final String? specialization;
  final String? qualification;
  final String? licenseNumber;
  final int? yearsOfExperience;
  final String? hospitalName;
  final String? address;
  final double? consultationFee;
  final String? bio;
  final double? longitude;
  final double? latitude;
  final bool? isAccepted;
  final String? commented;
  final bool? isSaved;
  final List<OpenDuration>? openDurations;

  DoctorModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
    super.phoneNumber,
    super.profileImage,
    super.city,
    super.type,
    this.specialization,
    this.qualification,
    this.licenseNumber,
    this.yearsOfExperience,
    this.hospitalName,
    this.address,
    this.consultationFee,
    this.bio,
    this.longitude,
    this.latitude,
    this.isAccepted,
    this.commented,
    this.isSaved,
    this.openDurations,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> json) {
    return DoctorModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      city: json['city'],
      type: json['type'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      licenseNumber: json['licenseNumber'],
      yearsOfExperience: json['yearsOfExperience'],
      hospitalName: json['hospitalName'],
      address: json['address'],
      consultationFee: (json['consultationFee'] as num?)?.toDouble(),
      bio: json['bio'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isAccepted: json['isAccepted'],
      commented: json['commented'],
      isSaved: json['isSaved'],
      openDurations: json['openDurations'] != null
          ? List<OpenDuration>.from(
              json['openDurations'].map((x) => OpenDuration.fromMap(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'qualification': qualification,
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      'hospitalName': hospitalName,
      'address': address,
      'consultationFee': consultationFee,
      'bio': bio,
      'latitude': latitude,
      'longitude': longitude,
      'isAccepted': isAccepted,
      'commented': commented,
      'isSaved': isSaved,
      'openDurations': openDurations?.map((x) => x.toMap()).toList(),
    });
    return map;
  }

  @override
  String toJson() => json.encode(toMap());

  @override
  DoctorModel copyWith({
    String? uid,
    String? email,
    String? name,
    DateTime? createdAt,
    String? phoneNumber,
    String? profileImage,
    String? city,
    String? type,
    String? specialization,
    String? qualification,
    String? licenseNumber,
    int? yearsOfExperience,
    String? hospitalName,
    String? address,
    double? consultationFee,
    String? bio,
    double? longitude,
    double? latitude,
    bool? isAccepted,
    String? commented,
    bool? isSaved,
    List<OpenDuration>? openDurations,
  }) {
    return DoctorModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      city: city ?? this.city,
      type: type ?? this.type,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      hospitalName: hospitalName ?? this.hospitalName,
      address: address ?? this.address,
      consultationFee: consultationFee ?? this.consultationFee,
      bio: bio ?? this.bio,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      isAccepted: isAccepted ?? this.isAccepted,
      commented: commented ?? this.commented,
      isSaved: isSaved ?? this.isSaved,
      openDurations: openDurations ?? this.openDurations,
    );
  }

 
}
extension DoctorModelExtension on DoctorModel {
   Map<String, Map<String, String?>> mapToDayAvailability(
      ) {
    final Map<String, Map<String, String?>> availability = {};
    if(openDurations== null) return availability;
    for (final duration in openDurations!) {
      if (duration.day != null) {
        availability[duration.day!] = {
          'startTime': duration.startTime,
          'endTime': duration.endTime,
        };
      }
    }

    return availability;
  }

  Map<String, bool> mapToDayIsClosed() {
    final Map<String, bool> isClosedMap = {};
  if(openDurations== null) return isClosedMap;
    for (final duration in openDurations!) {
      if (duration.day != null) {
        isClosedMap[duration.day!] = duration.isClosed ?? false;
      }
    }

    return isClosedMap;
  }
}
class OpenDuration {
  final String? day;
  final String? startTime;
  final String? endTime;
  final bool? isClosed;
  OpenDuration({
    this.day,
    this.startTime,
    this.endTime,
    this.isClosed,
  });

  OpenDuration copyWith({
    String? day,
    String? startTime,
    String? endTime,
    bool? isClosed,
  }) {
    return OpenDuration(
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'isClosed': isClosed,
    };
  }

  factory OpenDuration.fromMap(Map<String, dynamic> map) {
    return OpenDuration(
      day: map['day'] != null ? map['day'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      isClosed: map['isClosed'] != null ? map['isClosed'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OpenDuration.fromJson(String source) =>
      OpenDuration.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OpenDuration(day: $day, startTime: $startTime, endTime: $endTime, isClosed: $isClosed)';
  }

  @override
  bool operator ==(covariant OpenDuration other) {
    if (identical(this, other)) return true;

    return other.day == day &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isClosed == isClosed;
  }

  @override
  int get hashCode {
    return day.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        isClosed.hashCode;
  }
}
