// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:alagy/core/common/enities/user_model.dart';

class DoctorModel extends UserModel {
  final String? specialization;
  final String? qualification;
  final String? licenseNumber;
  final int? yearsOfExperience;
  final String? hospitalName;
  final String? address;
  final String? nameLower;
  final String? cityLower;
  final double? consultationFee;
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
    this.isVip = false,
    this.rating = 0,
    this.nameLower,
    this.cityLower,
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
    cityLower: json['cityLower'],
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
      "isVip": isVip,
      'specialization': specialization,
      "rating": rating,
      "nameLower": nameLower,
      "cityLower": cityLower,
      'qualification': qualification,
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      "reviews": reviews.map((x) => x.toMap()).toList(),
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
    double? rating,
    DateTime? createdAt,
    String? phoneNumber,
    String? profileImage,
    String? city,
    String? type,
    String? cityLower,
    String? nameLower,
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
    List<Review>? reviews,
    bool? isSaved,
    bool? isVip,
    List<OpenDuration>? openDurations,
  }) {
    return DoctorModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      isVip: isVip ?? this.isVip,
      createdAt: createdAt ?? this.createdAt,
      reviews: reviews ?? this.reviews,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      city: city ?? this.city,
      cityLower: cityLower ?? this.cityLower,
      nameLower: nameLower ?? this.nameLower,
      type: type ?? this.type,
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

class DoctorFakeData {
  static final List<DoctorModel> fakeDoctors = [
    DoctorModel(
      uid: '1',
      rating: 4.5,
      name: 'Dr. Sarah Khan',
      nameLower: 'Dr. Sarah Khan'.toLowerCase(),
      cityLower: 'Riyadh'.toLowerCase(),
      email: 'sarah.khan@example.com',
      phoneNumber: '+966501234567',
      profileImage: 'https://randomuser.me/api/portraits/women/1.jpg',
      city: 'Riyadh',
      createdAt: DateTime.now(),
      type: 'doctor',
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      specialization: 'Cardiologist',
      qualification: 'MD, FACC',
      licenseNumber: 'KSA-001234',
      yearsOfExperience: 15,
      hospitalName: 'Royal Heart Institute',
      address: 'King Fahad Road, Riyadh',
      consultationFee: 300.0,
      bio: 'Expert in interventional cardiology and preventive care.',
      longitude: 46.6753,
      latitude: 24.7136,
      isAccepted: true,
      isVip: true,
      commented: 'Top-rated heart specialist',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Sunday',
            startTime: '08:00 AM',
            endTime: '02:00 PM',
            isClosed: false),
        OpenDuration(
            day: 'Monday',
            startTime: '10:00 AM',
            endTime: '04:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      nameLower: 'Ali Ahmad'.toLowerCase(),
      cityLower: 'Jeddah'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      uid: '2',
      rating: 4,
      name: 'Dr. Ahmed Al Saud',
      email: 'ahmed.saud@example.com',
      phoneNumber: '+966501122334',
      profileImage: 'https://randomuser.me/api/portraits/men/2.jpg',
      city: 'Jeddah',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Dermatologist',
      qualification: 'MBBS, DDVL',
      licenseNumber: 'KSA-007654',
      yearsOfExperience: 10,
      hospitalName: 'Skin Health Clinic',
      address: 'Corniche Road, Jeddah',
      consultationFee: 200.0,
      bio: 'Specialist in skin treatment and cosmetic dermatology.',
      longitude: 39.1979,
      latitude: 21.4858,
      isAccepted: true,
      isVip: false,
      commented: 'Highly recommended',
      isSaved: true,
      openDurations: [
        OpenDuration(
            day: 'Tuesday',
            startTime: '09:00 AM',
            endTime: '03:00 PM',
            isClosed: false),
        OpenDuration(
            day: 'Wednesday',
            startTime: '01:00 PM',
            endTime: '06:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '3',
      nameLower: 'Dr. Aisha Al Hamdan'.toLowerCase(),
      cityLower: 'Dammam'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      rating: 4.9,
      name: 'Dr. Aisha Al Hamdan',
      email: 'aisha.hamdan@example.com',
      phoneNumber: '+966502223344',
      profileImage: 'https://randomuser.me/api/portraits/women/3.jpg',
      city: 'Dammam',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Pediatrician',
      qualification: 'MD, DCH',
      licenseNumber: 'KSA-002345',
      yearsOfExperience: 12,
      hospitalName: 'Kids Care Center',
      address: 'Prince Nayef Street, Dammam',
      consultationFee: 180.0,
      bio: 'Caring for children\'s health with compassion.',
      longitude: 50.0888,
      latitude: 26.3927,
      isAccepted: true,
      isVip: true,
      commented: 'Excellent with kids',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Saturday',
            startTime: '09:00 AM',
            endTime: '01:00 PM',
            isClosed: false),
        OpenDuration(
            day: 'Sunday',
            startTime: '02:00 PM',
            endTime: '06:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '4',
      nameLower: 'Dr. Khalid Al Qahtani'.toLowerCase(),
      cityLower: 'Makkah'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      rating: 4.2,
      name: 'Dr. Khalid Al Qahtani',
      email: 'khalid.qahtani@example.com',
      phoneNumber: '+966503334455',
      profileImage: 'https://randomuser.me/api/portraits/men/4.jpg',
      city: 'Makkah',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Neurologist',
      qualification: 'MD, DM (Neuro)',
      licenseNumber: 'KSA-003456',
      yearsOfExperience: 20,
      hospitalName: 'NeuroCare Hospital',
      address: 'Al Shohada District, Makkah',
      consultationFee: 350.0,
      bio: 'Specialist in neurological disorders and stroke treatment.',
      longitude: 39.8256,
      latitude: 21.3891,
      isAccepted: true,
      isVip: true,
      commented: 'Neuro expert',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Monday',
            startTime: '09:00 AM',
            endTime: '12:00 PM',
            isClosed: false),
        OpenDuration(
            day: 'Thursday',
            startTime: '10:00 AM',
            endTime: '03:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '5',
      rating: 4.1,
      nameLower: 'Dr. Layla Al Harbi'.toLowerCase(),
      cityLower: 'Abha'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Layla Al Harbi',
      email: 'layla.harbi@example.com',
      phoneNumber: '+966504445566',
      profileImage: 'https://randomuser.me/api/portraits/women/5.jpg',
      city: 'Abha',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Gynecologist',
      qualification: 'MD, MS (Ob-Gyn)',
      licenseNumber: 'KSA-004567',
      yearsOfExperience: 14,
      hospitalName: 'Women Wellness Center',
      address: 'King Abdulaziz Road, Abha',
      consultationFee: 250.0,
      bio: 'Dedicated to women\'s health and maternity care.',
      longitude: 42.5053,
      latitude: 18.2164,
      isAccepted: true,
      isVip: false,
      commented: 'Trusted by many mothers',
      isSaved: true,
      openDurations: [
        OpenDuration(
            day: 'Sunday',
            startTime: '10:00 AM',
            endTime: '04:00 PM',
            isClosed: false),
        OpenDuration(
            day: 'Tuesday',
            startTime: '09:00 AM',
            endTime: '01:00 PM',
            isClosed: false),
      ],
    ),
    // Add 5 more fake doctors as needed...
    DoctorModel(
      uid: '6',
      rating: 4.7,
      nameLower: 'Dr. Majid Al Dossary'.toLowerCase(),
      cityLower: 'Medina'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Majid Al Dossary',
      email: 'majid.dossary@example.com',
      phoneNumber: '+966505556677',
      profileImage: 'https://randomuser.me/api/portraits/men/6.jpg',
      city: 'Medina',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Orthopedic Surgeon',
      qualification: 'MBBS, MS (Ortho)',
      licenseNumber: 'KSA-005678',
      yearsOfExperience: 18,
      hospitalName: 'Bone & Joint Hospital',
      address: 'Quba Street, Medina',
      consultationFee: 280.0,
      bio: 'Skilled in treating fractures and joint issues.',
      longitude: 39.5692,
      latitude: 24.5247,
      isAccepted: true,
      isVip: false,
      commented: 'Efficient and skilled',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Wednesday',
            startTime: '08:00 AM',
            endTime: '12:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '7',
      rating: 3.6,
      nameLower: 'Dr. Rania Al Zahrani'.toLowerCase(),
      cityLower: 'Tabuk'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Rania Al Zahrani',
      email: 'rania.zahrani@example.com',
      phoneNumber: '+966506667788',
      profileImage: 'https://randomuser.me/api/portraits/women/7.jpg',
      city: 'Tabuk',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'Psychiatrist',
      qualification: 'MD, MRC Psych',
      licenseNumber: 'KSA-006789',
      yearsOfExperience: 9,
      hospitalName: 'Mind Wellness Clinic',
      address: 'Al Rawdah, Tabuk',
      consultationFee: 220.0,
      bio: 'Passionate about mental wellness and therapy.',
      longitude: 36.5559,
      latitude: 28.3838,
      isAccepted: true,
      isVip: true,
      commented: 'Empathetic and understanding',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Saturday',
            startTime: '01:00 PM',
            endTime: '05:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '8',
      rating: 4.8,
      nameLower: 'Dr. Yasser Al Sulaiman'.toLowerCase(),
      cityLower: 'Khobar'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Yasser Al Sulaiman',
      email: 'yasser.sulaiman@example.com',
      phoneNumber: '+966507778899',
      profileImage: 'https://randomuser.me/api/portraits/men/8.jpg',
      city: 'Khobar',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'ENT Specialist',
      qualification: 'MBBS, MS (ENT)',
      licenseNumber: 'KSA-007890',
      yearsOfExperience: 13,
      hospitalName: 'Hearing & Voice Center',
      address: 'Al Aqrabiyah, Khobar',
      consultationFee: 240.0,
      bio: 'Experienced in ENT surgeries and treatments.',
      longitude: 50.2105,
      latitude: 26.2794,
      isAccepted: true,
      isVip: false,
      commented: 'Detailed consultation',
      isSaved: true,
      openDurations: [
        OpenDuration(
            day: 'Monday',
            startTime: '03:00 PM',
            endTime: '08:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '9',
      nameLower: 'Dr. Mona Al Qahtani'.toLowerCase(),
      cityLower: 'Najran'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Mona Al Qahtani',
      email: 'mona.qahtani@example.com',
      phoneNumber: '+966508889900',
      profileImage: 'https://randomuser.me/api/portraits/women/9.jpg',
      city: 'Najran',
      createdAt: DateTime.now(),
      type: 'doctor',
      rating: 3,
      specialization: 'Ophthalmologist',
      qualification: 'MBBS, MS (Ophthalmology)',
      licenseNumber: 'KSA-008901',
      yearsOfExperience: 11,
      hospitalName: 'Vision Eye Hospital',
      address: 'King Saud Street, Najran',
      consultationFee: 260.0,
      bio: 'Helping people see the world clearly.',
      longitude: 44.4194,
      latitude: 17.4917,
      isAccepted: true,
      isVip: false,
      commented: 'Vision specialist',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Sunday',
            startTime: '11:00 AM',
            endTime: '05:00 PM',
            isClosed: false),
      ],
    ),
    DoctorModel(
      uid: '10',
      rating: 4.7,
      nameLower: 'Dr. Faisal Al Nasser'.toLowerCase(),
      cityLower: 'Hail'.toLowerCase(),
      reviews: [
        Review(
          userId: 'u1',
          userName: 'Ali Ahmad',
          comment: 'Very professional and friendly.',
          rating: 4.5,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        ),
        Review(
          userId: 'u2',
          userName: 'Nora Saleh',
          comment: 'Explains everything clearly.',
          rating: 5.0,
          createdAt: DateTime.now(),
          doctorId: '1',
          userImageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        ),
      ],
      name: 'Dr. Faisal Al Nasser',
      email: 'faisal.nasser@example.com',
      phoneNumber: '+966509990011',
      profileImage: 'https://randomuser.me/api/portraits/men/10.jpg',
      city: 'Hail',
      createdAt: DateTime.now(),
      type: 'doctor',
      specialization: 'General Practitioner',
      qualification: 'MBBS',
      licenseNumber: 'KSA-009012',
      yearsOfExperience: 7,
      hospitalName: 'Family Health Center',
      address: 'Al Salam Street, Hail',
      consultationFee: 150.0,
      bio: 'Reliable primary care for your family.',
      longitude: 41.6868,
      latitude: 27.5219,
      isAccepted: true,
      isVip: false,
      commented: 'Friendly and helpful',
      isSaved: false,
      openDurations: [
        OpenDuration(
            day: 'Thursday',
            startTime: '08:00 AM',
            endTime: '02:00 PM',
            isClosed: false),
      ],
    ),
  ];
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
