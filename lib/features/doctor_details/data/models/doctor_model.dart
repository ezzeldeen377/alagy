// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


import 'package:alagy/core/common/enities/user_model.dart';

class DoctorModel extends UserModel {
  final String? specialization;
  final String? qualification;
  final String? licenseNumber;
  final int? yearsOfExperience;
  final String? hospitalName;
  final String? address;
  final String? nameLower;
  final String? addressLower;
  final double? consultationFee;
  final double? returningFees;  // Add this line
  final String? bio;
  final double? longitude;
  final double? latitude;
  final bool? isAccepted;
  final String? commented;
  final bool? isSaved;
  final bool? isVip;
  final List<OpenDuration>? openDurations;
  final double? rating;
  final List<Review> reviews;

  DoctorModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    super.notificationToken,
    this.isVip = false,
    this.rating = 0,
    this.nameLower,
    this.addressLower,
    super.phoneNumber,
    super.profileImage,
    super.city,
    super.type,
    this.reviews = const [],
    this.specialization,
    this.qualification,
    this.licenseNumber,
    this.yearsOfExperience,
    this.hospitalName,
    this.address,
    this.consultationFee,
    this.returningFees,  // Add this line
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
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']??DateTime.now().millisecondsSinceEpoch),
      rating: Review.calculateAverageRating(
        (json['reviews'] != null && json['reviews'] is List)
            ? List<Review>.from(json['reviews'].map((x) => Review.fromMap(x)))
            : [],
      ),
      name: json['name'],
      email: json['email'],
      isVip: json['isVip'] ?? false, // Add default value for null safety
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      phoneNumber: json['phoneNumber'],
      reviews: (json['reviews'] != null && json['reviews'] is List)
          ? List<Review>.from(json['reviews'].map((x) => Review.fromMap(x)))
          : [], // Add null check for reviews
      nameLower: json['nameLower'],
      addressLower: json['addressLower'],
      profileImage: json['profileImage'],
      city: json['city'],
      type: json['type'],
      notificationToken: json['notificationToken'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      licenseNumber: json['licenseNumber'],
      yearsOfExperience: json['yearsOfExperience'],
      hospitalName: json['hospitalName'],
      address: json['address'],
      consultationFee: (json['consultationFee'] as num?)?.toDouble(),
      returningFees: (json['returningFees'] as num?)?.toDouble(),  // Add this line
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
      "isVip": isVip,
      'specialization': specialization,
      "rating": rating,
      "nameLower": nameLower,
      "addressLower": addressLower,
      'qualification': qualification,
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      "reviews": reviews.map((x) => x.toMap()).toList(),
      'hospitalName': hospitalName,
      'address': address,
      "notificationToken": notificationToken,
      'consultationFee': consultationFee,
      'returningFees': returningFees,  // Add this line
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
    double? rating,
    DateTime? createdAt,
    String? phoneNumber,
    String? profileImage,
    String? city,
    String? type,
    String? addressLower,
    String? notificationToken,
    String? nameLower,
    String? specialization,
    String? qualification,
    String? licenseNumber,
    int? yearsOfExperience,
    String? hospitalName,
    String? address,
    double? consultationFee,
    double? returningFees,  // Add this line
    String? bio,
    double? longitude,
    double? latitude,
    bool? isAccepted,
    String? commented,
    List<Review>? reviews,
    bool? isSaved,
    bool? isVip,
    List<OpenDuration>? openDurations,
    DateTime? updatedAt,
  }) {
    return DoctorModel(
      updatedAt: updatedAt ?? this.updatedAt,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      isVip: isVip ?? this.isVip,
      notificationToken: notificationToken ?? this.notificationToken,
      createdAt: createdAt ?? this.createdAt,
      reviews: reviews ?? this.reviews,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      city: city ?? this.city,
      addressLower: addressLower ?? this.addressLower,
      nameLower: nameLower ?? this.nameLower,
      type: type ?? this.type,
      returningFees: returningFees ?? this.returningFees,  // Add this line
      rating: rating ?? this.rating,
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
  Map<String, Map<String, String?>> mapToDayAvailability() {
    final Map<String, Map<String, String?>> availability = {};
    if (openDurations == null) return availability;
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
    if (openDurations == null) return isClosedMap;
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

class Review {
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime createdAt;
  final String? doctorId;
  final String? userImageUrl; // Added field for user profile image

  Review({
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.doctorId,
    this.userImageUrl,
  });

  // Convert Review to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'doctorId': doctorId,
      'userImageUrl': userImageUrl,
    };
  }

  // Create Review from Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      comment: map['comment'] as String,
      rating: (map['rating'] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      doctorId: map['doctorId'] != null ? map['doctorId'] as String : null,
      userImageUrl:
          map['userImageUrl'] != null ? map['userImageUrl'] as String : null,
    );
  }

  // Calculate average rating
  static double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    final avg = total / reviews.length;

    print("total $total");
    print("avg $avg");
    return avg;
  }

  Review copyWith({
    String? userId,
    String? userName,
    String? comment,
    double? rating,
    DateTime? createdAt,
    String? doctorId,
    String? userImageUrl,
  }) {
    return Review(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      doctorId: doctorId ?? this.doctorId,
      userImageUrl: userImageUrl ?? this.userImageUrl,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Review(userId: $userId, userName: $userName, comment: $comment, rating: $rating, createdAt: $createdAt, doctorId: $doctorId, userImageUrl: $userImageUrl)';
  }

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.comment == comment &&
        other.rating == rating &&
        other.createdAt == createdAt &&
        other.doctorId == doctorId &&
        other.userImageUrl == userImageUrl;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        comment.hashCode ^
        rating.hashCode ^
        createdAt.hashCode ^
        doctorId.hashCode ^
        userImageUrl.hashCode;
  }
}
