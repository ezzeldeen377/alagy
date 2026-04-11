import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/payment/data/data_source/payment_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:alagy/features/payment/data/models/payment_model.dart'; // Add

abstract class PaymentRepository {
  Future<Map<String, dynamic>> createIntention({
    required Map<String, dynamic> payload,
  });

  Future<void> savePayment(PaymentModel payment);

  Future<List<PaymentModel>> getPayments(String userId);
}

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _dataSource;

  PaymentRepositoryImpl({required PaymentRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Map<String, dynamic>> createIntention({
    required Map<String, dynamic> payload,
  }) {
    return _dataSource.createIntention(payload: payload);
  }

  @override
  Future<void> savePayment(PaymentModel payment) {
    return _dataSource.savePayment(payment);
  }

  @override
  Future<List<PaymentModel>> getPayments(String userId) {
    return _dataSource.getPayments(userId);
  }
}
