import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final DateTime date;
  final String status;
  final String method;
  final String description;
  final String transactionId;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.status,
    required this.method,
    required this.description,
    required this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      status: json['status'] ?? '',
      method: json['method'] ?? '',
      description: json['description'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'status': status,
      'method': method,
      'description': description,
      'transactionId': transactionId,
    };
  }
}
