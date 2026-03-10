enum AppointmentStatus { pending, confirmed, cancelled, completed }

enum PaymentStatus { unpaid, paid, refunded }

enum AppointmentType { consultation, returning }

class DoctorAppointment {
  final String? id;
  final String doctorId;
  final String doctorName;
  final String? doctorNotificationToken; 
  final String patientId;
  final String patientName;
  final String specialization;
  final DateTime appointmentDate;
  final TimeSlot startTime;
  final String? endTime;
  final String? location;
  final bool? isOnline;
  final AppointmentStatus status;
  final AppointmentType appointmentType;
  final double price;
  final PaymentStatus paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final String? patientNotificationToken;
  final DateTime updatedAt;

  DoctorAppointment({
    this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
    required this.specialization,
    required this.appointmentDate,
    required this.startTime,
    this.endTime,
    this.location,
    this.isOnline,
    required this.status,
    required this.appointmentType,
    required this.price,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.doctorNotificationToken,
    this.patientNotificationToken,
  });

  factory DoctorAppointment.fromMap(Map<String, dynamic> map) {
    return DoctorAppointment(
      id: map['id'] as String,
      doctorId: map['doctorId'] as String,
      doctorName: map['doctorName'] as String,
      patientId: map['patientId'] as String,
      patientName: map['patientName'] as String,
      specialization: map['specialization'] as String,
      appointmentDate:
          DateTime.parse(map['appointmentDate']).normalizeDateOnly,
      startTime: TimeSlot.fromMap(map['startTime'] as Map<String, dynamic>) ,
      endTime: map['endTime'] as String?,
      location: map['location'] as String?,
      isOnline: map['isOnline'] as bool?,
      status: _statusFromString(map['status']),
      appointmentType: _appointmentTypeFromString(map['appointmentType'] ?? 'consultation'),
      price: (map['price'] as num).toDouble(),
      paymentStatus: _paymentStatusFromString(map['paymentStatus']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      doctorNotificationToken: map['doctorNotificationToken'] as String?,
      patientNotificationToken: map['patientNotificationToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'patientName': patientName,
      'specialization': specialization,
      'appointmentDate': appointmentDate.toIso8601String(),
      'startTime': startTime.toMap(),
      'endTime': endTime,
      'location': location,
      'isOnline': isOnline,
      'status': status.name,
      'appointmentType': appointmentType.name,
      'price': price,
      'paymentStatus': paymentStatus.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'doctorNotificationToken': doctorNotificationToken,
      'patientNotificationToken': patientNotificationToken,
    };
  }

  DoctorAppointment copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? patientId,
    String? patientName,
    String? specialization,
    DateTime? appointmentDate,
    TimeSlot? startTime,
    String? endTime,
    String? location,
    bool? isOnline,
    AppointmentStatus? status,
    AppointmentType? appointmentType,
    double? price,
    PaymentStatus? paymentStatus,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorAppointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      specialization: specialization ?? this.specialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
      appointmentType: appointmentType ?? this.appointmentType,
      price: price ?? this.price,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helpers for enum mapping
  static AppointmentStatus _statusFromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => AppointmentStatus.pending,
    );
  }

  static PaymentStatus _paymentStatusFromString(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentStatus.unpaid,
    );
  }

  static AppointmentType _appointmentTypeFromString(String type) {
    return AppointmentType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => AppointmentType.consultation,
    );
  }
}

class TimeSlot {
  final String time; // e.g., "9:00 AM"
  final bool isAvailable;

  TimeSlot({
    required this.time,
    this.isAvailable = true,
  });

  // Factory constructor to create TimeSlot from Map
  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      time: map['time'] as String,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }

  // Convert TimeSlot to Map
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'isAvailable': isAvailable,
    };
  }

  // Create a copy with optional updated fields
  TimeSlot copyWith({
    String? time,
    bool? isAvailable,
  }) {
    return TimeSlot(
      time: time ?? this.time,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

extension NormalizeDate on DateTime {
  /// Returns a new DateTime with only year, month, and day.
  DateTime get normalizeDateOnly => DateTime(year, month, day);
}

/// Extension on TimeSlot to provide convenient time formatting
extension TimeSlotFormatting on TimeSlot {
  /// Converts time string to DateTime object for today's date
  DateTime toDateTime() {
    final timeParts = time.split(' ');
    final timeComponents = timeParts[0].split(':');
    final period = timeParts[1];
    
    int hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);
    
    // Convert to 24 hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month, 
      now.day,
      hour,
      minute,
    );
  }

  /// Returns formatted time string (e.g., "9:00 AM", "2:30 PM")
  String formatTime() {
    final dateTime = toDateTime();
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Returns 24-hour format time string (e.g., "09:00", "14:30")
  String format24Hour() {
    final dateTime = toDateTime();
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Returns time with seconds (e.g., "9:00:00 AM")
  String formatWithSeconds() {
    final dateTime = toDateTime();
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute:00 $period';
  }
}
