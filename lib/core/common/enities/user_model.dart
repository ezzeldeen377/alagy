import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? type;
  final String? city;
  final String? signFrom;
  final String? profileImage;
  final String? phoneNumber;
   bool? spamer;
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.type,
    this.city,
    required this.signFrom,
    this.profileImage,
    this.phoneNumber,
    this.spamer,
  });
  // Add any other fields you need

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    DateTime? createdAt,
    String? type,
    String? city,
    String? signFrom,
    String? profileImage,
    String? phoneNumber,
    bool? spamer,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      city: city ?? this.city,
      signFrom: signFrom ?? this.signFrom,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      spamer: spamer ?? this.spamer,
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
      'signFrom': signFrom,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'spamer': spamer,
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
      signFrom: map['signFrom'] != null ? map['signFrom'] as String : null,
      profileImage: map['profileImage'] != null ? map['profileImage'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      spamer: map['spamer'] != null ? map['spamer'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, createdAt: $createdAt, type: $type, city: $city, signFrom: $signFrom, profileImage: $profileImage, phoneNumber: $phoneNumber, spamer: $spamer)';
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
      other.city == city &&
      other.signFrom == signFrom &&
      other.profileImage == profileImage &&
      other.phoneNumber == phoneNumber &&
      other.spamer == spamer;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      name.hashCode ^
      createdAt.hashCode ^
      type.hashCode ^
      city.hashCode ^
      signFrom.hashCode ^
      profileImage.hashCode ^
      phoneNumber.hashCode ^
      spamer.hashCode;
  }
}
