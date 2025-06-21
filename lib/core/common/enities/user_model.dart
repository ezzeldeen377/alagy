// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? type;
  final String? city;
  final String? profileImage;
  final String? phoneNumber;
  final bool? isSaved;
  final String? notificationToken;
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.type,
    this.city,
    this.profileImage,
    this.phoneNumber,
    this.notificationToken,
    this.isSaved,
  });
  // Add any other fields you need

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    DateTime? createdAt,
    String? type,
    String? city,
    String? profileImage,
    String? phoneNumber,
    String? notificationToken,
    bool? isSaved,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      city: city ?? this.city,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSaved: isSaved ?? this.isSaved,
      notificationToken: notificationToken?? this.notificationToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'type': type,
      'city': city,
      'profileImage': profileImage,
      "notificationToken": notificationToken,
      'phoneNumber': phoneNumber,
      'isSaved': isSaved,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      type: map['type'] != null ? map['type'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      notificationToken: map['notificationToken']!= null? map['notificationToken'] as String : null,
      profileImage: map['profileImage'] != null ? map['profileImage'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      isSaved: map['isSaved'] != null ? map['isSaved'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email,notificationToken :$notificationToken, name: $name, createdAt: $createdAt, type: $type, city: $city, profileImage: $profileImage, phoneNumber: $phoneNumber, isSaved: $isSaved)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.email == email &&
      other.name == name &&
      other.createdAt == createdAt &&
      other.type == type &&
      other.notificationToken==notificationToken &&
      other.city == city &&
      other.profileImage == profileImage &&
      other.phoneNumber == phoneNumber &&
      other.isSaved == isSaved;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      name.hashCode ^
      createdAt.hashCode ^
      notificationToken.hashCode ^
      type.hashCode ^
      city.hashCode ^
      profileImage.hashCode ^
      phoneNumber.hashCode ^
      isSaved.hashCode;
  }
}
