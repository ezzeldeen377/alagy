import 'dart:convert';

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
  }) ;

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
      longitude: longitude?? this.longitude,
      latitude: latitude?? this.latitude,
    );
  }
}
