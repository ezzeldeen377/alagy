import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/admin/data/models/discount_code_model.dart';
import 'package:alagy/features/discount/data/datasources/discount_code_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

abstract class DiscountCodeRepository {
  Future<Either<Failure, DiscountCodeModel?>> validateDiscountCode(String code);
  Future<Either<Failure, void>> incrementDiscountCodeUsage(String codeId);
}

@Injectable(as: DiscountCodeRepository)
class DiscountCodeRepositoryImpl implements DiscountCodeRepository {
  final DiscountCodeRemoteDataSource _remoteDataSource;

  DiscountCodeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DiscountCodeModel?>> validateDiscountCode(String code) {
    return executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.validateDiscountCode(code);
    });
  }

  @override
  Future<Either<Failure, void>> incrementDiscountCodeUsage(String codeId) {
    return executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.incrementDiscountCodeUsage(codeId);
    });
  }
}