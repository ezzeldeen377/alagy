import 'package:alagy/core/error/failure.dart';
import 'package:alagy/features/admin/data/models/admin_statistics.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<DoctorModel>>> getPendingDoctors();
  Future<Either<Failure, List<DoctorModel>>> getApprovedDoctors();
  Future<Either<Failure, List<DoctorModel>>> getRejectedDoctors();
  Future<Either<Failure, void>> approveDoctor(String doctorId);
  Future<Either<Failure, void>> rejectDoctor(String doctorId);
  Future<Either<Failure, AdminStatistics>> getStatistics([DateFilter? filter]);
  Future<Either<Failure, void>> updateDoctorStatus(String doctorId, bool isAccepted);
  Future<Either<Failure, void>> updateDoctorVipStatus(String doctorId, bool isVip);
}