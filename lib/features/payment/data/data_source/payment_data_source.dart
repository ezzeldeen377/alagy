import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/features/payment/data/models/payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:injectable/injectable.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> createIntention({
    required Map<String, dynamic> payload,
  });

  Future<void> savePayment(PaymentModel payment);

  Future<List<PaymentModel>> getPayments(String userId);
}

@Injectable(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client _client = http.Client();

  final String _baseUrl = paymentKeys.baseUrl;
  final String _clientSecret = paymentKeys.clientSecret;

  @override
  Future<Map<String, dynamic>> createIntention({
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse(_baseUrl);
    final response = await _client.post(
      url,
      headers: {
        "Authorization": "Token $_clientSecret",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create intention: ${response.body}');
    }
  }

  @override
  Future<void> savePayment(PaymentModel payment) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.paymentsCollection)
        .doc(payment.id)
        .set(payment.toJson());
  }

  @override
  Future<List<PaymentModel>> getPayments(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirebaseCollections.paymentsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((e) => PaymentModel.fromJson(e.data())).toList();
  }
}
