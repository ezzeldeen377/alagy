// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? type;
  final String? city;
  final String? profileImage;
  final String? phoneNumber;
  final bool? isSaved;
  final String? notificationToken;
  final double walletBalance;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.city,
    this.profileImage,
    this.phoneNumber,
    this.notificationToken,
    this.isSaved,
    this.walletBalance = 0.0,
  });
  // Add any other fields you need

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    String? city,
    String? profileImage,
    String? phoneNumber,
    String? notificationToken,
    bool? isSaved,
    double? walletBalance,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      city: city ?? this.city,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSaved: isSaved ?? this.isSaved,
      notificationToken: notificationToken ?? this.notificationToken,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'type': type,
      'city': city,
      'profileImage': profileImage,
      "notificationToken": notificationToken,
      'phoneNumber': phoneNumber,
      'isSaved': isSaved,
      'walletBalance': walletBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      type: map['type'] != null ? map['type'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      notificationToken: map['notificationToken'] != null
          ? map['notificationToken'] as String
          : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      isSaved: map['isSaved'] != null ? map['isSaved'] as bool : null,
      walletBalance: (map['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.parse(value);
    if (value.runtimeType.toString() == 'Timestamp' ||
        value.toString().contains('Timestamp')) {
      try {
        return (value as dynamic).toDate();
      } catch (_) {}
    }
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now(); // Fallback
    }
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email,notificationToken :$notificationToken, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, type: $type, city: $city, profileImage: $profileImage, phoneNumber: $phoneNumber, isSaved: $isSaved, walletBalance: $walletBalance)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.type == type &&
        other.notificationToken == notificationToken &&
        other.city == city &&
        other.profileImage == profileImage &&
        other.phoneNumber == phoneNumber &&
        other.isSaved == isSaved &&
        other.walletBalance == walletBalance;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        notificationToken.hashCode ^
        type.hashCode ^
        city.hashCode ^
        profileImage.hashCode ^
        phoneNumber.hashCode ^
        isSaved.hashCode ^
        walletBalance.hashCode;
  }
}
