import 'package:alagy/core/error/failure.dart';
import 'package:alagy/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:alagy/features/admin/data/models/admin_statistics.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/admin/data/repositories/admin_repository.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorModel>>> getPendingDoctors() async {
    try {
      final doctors = await _remoteDataSource.getPendingDoctors();
      return Right(doctors);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorModel>>> getApprovedDoctors() async {
    try {
      final doctors = await _remoteDataSource.getApprovedDoctors();
      return Right(doctors);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorModel>>> getRejectedDoctors() async {
    try {
      final doctors = await _remoteDataSource.getRejectedDoctors();
      return Right(doctors);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveDoctor(String doctorId) async {
    try {
      await _remoteDataSource.updateDoctorStatus(doctorId, true);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectDoctor(String doctorId) async {
    try {
      await _remoteDataSource.updateDoctorStatus(doctorId, false);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminStatistics>> getStatistics([DateFilter? filter]) async {
    try {
      final statistics = await _remoteDataSource.getStatistics(filter ?? DateFilter.allTime);
      return Right(statistics);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctorStatus(String doctorId, bool isAccepted) async {
    try {
      await _remoteDataSource.updateDoctorStatus(doctorId, isAccepted);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctorVipStatus(String doctorId, bool isVip) async {
    try {
      await _remoteDataSource.updateDoctorVipStatus(doctorId, isVip);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}