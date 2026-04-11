import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/datasources/doctor_dashboard_remote_data_source.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, Map<String, int>>> getDoctorStatistics(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getTodayAppointments(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getPendingRequests(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getAllAppointments(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getPendingAppointments(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getCompletedAppointments(String doctorId);
  Future<Either<Failure, void>> updateAppointmentStatus(String appointmentId, AppointmentStatus status);
}

@Injectable(as: DoctorDashboardRepository)
class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource _dataSource;

  DoctorDashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Map<String, int>>> getDoctorStatistics(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getDoctorStatistics(doctorId);
    });
  }

  @override
  Future<Either<Failure, List<DoctorAppointment>>> getTodayAppointments(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      final data = await _dataSource.getTodayAppointments(doctorId);
      return data.map((json) => DoctorAppointment.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<DoctorAppointment>>> getPendingRequests(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      final data = await _dataSource.getPendingRequests(doctorId);
      return data.map((json) => DoctorAppointment.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<DoctorAppointment>>> getAllAppointments(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      final data = await _dataSource.getAllAppointments(doctorId);
      return data.map((json) => DoctorAppointment.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<DoctorAppointment>>> getPendingAppointments(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      final data = await _dataSource.getPendingAppointments(doctorId);
      return data.map((json) => DoctorAppointment.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<DoctorAppointment>>> getCompletedAppointments(String doctorId) {
    return executeTryAndCatchForRepository(() async {
      final data = await _dataSource.getCompletedAppointments(doctorId);
      return data.map((json) => DoctorAppointment.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus(String appointmentId, AppointmentStatus status) {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.updateAppointmentStatus(appointmentId, status);
    });
  }
}