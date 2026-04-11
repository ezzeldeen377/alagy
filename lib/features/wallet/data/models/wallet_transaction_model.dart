import 'package:cloud_firestore/cloud_firestore.dart';

enum WalletTransactionType { refund, withdraw, payment }

enum WalletTransactionStatus { completed, pending, failed }

class WalletTransactionModel {
  final String id;
  final String userId;
  final double amount;
  final WalletTransactionType type;
  final WalletTransactionStatus status;
  final String? description;
  final String? relatedAppointmentId;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    this.relatedAppointmentId,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return WalletTransactionModel(
      id: documentId,
      userId: map['userId'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: WalletTransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => WalletTransactionType.refund,
      ),
      status: WalletTransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => WalletTransactionStatus.completed,
      ),
      description:
          map['description'] != null ? map['description'] as String : null,
      relatedAppointmentId: map['relatedAppointmentId'] != null
          ? map['relatedAppointmentId'] as String
          : null,
      createdAt: _parseDateTime(map['createdAt']),
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

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'type': type.name,
      'status': status.name,
      'description': description,
      'relatedAppointmentId': relatedAppointmentId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  WalletTransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    WalletTransactionType? type,
    WalletTransactionStatus? status,
    String? description,
    String? relatedAppointmentId,
    DateTime? createdAt,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      relatedAppointmentId: relatedAppointmentId ?? this.relatedAppointmentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
