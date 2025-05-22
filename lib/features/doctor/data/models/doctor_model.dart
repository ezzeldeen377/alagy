
import 'package:alagy/core/common/enities/user_model.dart';

class DoctorModel extends UserModel {
  final String specialization;
  final String qualification;
  final String licenseNumber;
  final int yearsOfExperience;
  final String hospitalName;
  final String address;
  final double consultationFee;
  final String? bio;

  DoctorModel({
    required String id,
    required String name,
    required String email,
    required String phone,
    required this.specialization,
    required this.qualification,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.hospitalName,
    required this.address,
    required this.consultationFee,
    String? profilePicture,
    this.bio,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          profilePicture: profilePicture,
          type: 'doctor',
        );

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      qualification: json['qualification'] as String,
      licenseNumber: json['licenseNumber'] as String,
      yearsOfExperience: json['yearsOfExperience'] as int,
      hospitalName: json['hospitalName'] as String,
      address: json['address'] as String,
      consultationFee: (json['consultationFee'] as num).toDouble(),
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialization': specialization,
      'qualification': qualification,
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      'hospitalName': hospitalName,
      'address': address,
      'consultationFee': consultationFee,
      'profilePicture': profilePicture,
      'bio': bio,
      'type': type,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? specialization,
    String? qualification,
    String? licenseNumber,
    int? yearsOfExperience,
    String? hospitalName,
    String? address,
    double? consultationFee,
    String? profilePicture,
    String? bio,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      hospitalName: hospitalName ?? this.hospitalName,
      address: address ?? this.address,
      consultationFee: consultationFee ?? this.consultationFee,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
    );
  }
}