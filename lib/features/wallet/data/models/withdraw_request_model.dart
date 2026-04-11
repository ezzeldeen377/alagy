import 'package:cloud_firestore/cloud_firestore.dart';

enum WithdrawMethod { bankAccount, instaPay, mobileWallet }

enum WithdrawStatus { pending, approved, declined }

class WithdrawRequestModel {
  final String id;
  final String userId;
  final String userName;
  final double amount;
  final WithdrawMethod method;
  final WithdrawStatus status;

  // Bank account fields
  final String? bankName;
  final String? accountNumber;
  final String? accountHolderName;

  // InstaPay fields
  final String? instaPayAccount;

  // Mobile wallet fields
  final String? mobileWalletNumber;
  final String? mobileWalletProvider;

  final String? transactionId;
  final String? adminNote;
  final DateTime? reviewedAt;
  final DateTime createdAt;

  WithdrawRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.method,
    required this.status,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
    this.instaPayAccount,
    this.mobileWalletNumber,
    this.mobileWalletProvider,
    this.transactionId,
    this.adminNote,
    this.reviewedAt,
    required this.createdAt,
  });

  factory WithdrawRequestModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return WithdrawRequestModel(
      id: documentId,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      amount: (map['amount'] as num).toDouble(),
      method: WithdrawMethod.values.firstWhere(
        (e) => e.name == map['method'],
      ),
      status: WithdrawStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => WithdrawStatus.pending,
      ),
      bankName: map['bankName'] as String?,
      accountNumber: map['accountNumber'] as String?,
      accountHolderName: map['accountHolderName'] as String?,
      instaPayAccount: map['instaPayAccount'] as String?,
      mobileWalletNumber: map['mobileWalletNumber'] as String?,
      mobileWalletProvider: map['mobileWalletProvider'] as String?,
      transactionId: map['transactionId'] as String?,
      adminNote: map['adminNote'] as String?,
      reviewedAt:
          map['reviewedAt'] != null ? _parseDateTime(map['reviewedAt']) : null,
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
      'userName': userName,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'instaPayAccount': instaPayAccount,
      'mobileWalletNumber': mobileWalletNumber,
      'mobileWalletProvider': mobileWalletProvider,
      'transactionId': transactionId,
      'adminNote': adminNote,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  WithdrawRequestModel copyWith({
    String? id,
    String? userId,
    String? userName,
    double? amount,
    WithdrawMethod? method,
    WithdrawStatus? status,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? instaPayAccount,
    String? mobileWalletNumber,
    String? mobileWalletProvider,
    String? transactionId,
    String? adminNote,
    DateTime? reviewedAt,
    DateTime? createdAt,
  }) {
    return WithdrawRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      instaPayAccount: instaPayAccount ?? this.instaPayAccount,
      mobileWalletNumber: mobileWalletNumber ?? this.mobileWalletNumber,
      mobileWalletProvider: mobileWalletProvider ?? this.mobileWalletProvider,
      transactionId: transactionId ?? this.transactionId,
      adminNote: adminNote ?? this.adminNote,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
