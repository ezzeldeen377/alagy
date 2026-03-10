import 'dart:io';

import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor_details/data/datasources/doctor_remote_data_source.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

abstract class DoctorRepository {
  Future<Either<Failure, Unit>> addDoctor(DoctorModel doctor);
  Future<Either<Failure, DoctorModel?>> getDoctor(String uid);
  Future<Either<Failure, DoctorModel?>> getDoctorById(String doctorId);
  Future<Either<Failure, List<DoctorAppointment>>> getDoctorAppointments(String doctorId);
  Future<Either<Failure, void>> updateAppointmentStatus(String appointmentId, AppointmentStatus status);

  Future<Either<Failure, String>> uploadProfilePicture(File image);
  Future<Either<Failure,DoctorModel>> addReview( Review review,double avgRate) ;
  Future<Either<Failure, void>> makeAppointment(DoctorAppointment appointment, String uid);
  Future<Either<Failure,List<DoctorAppointment>>> getDoctorAppointmentsAtDate(
      String doctorId, DateTime date) ;
}

@Injectable(as: DoctorRepository)
class DoctorRepositoryImpl extends DoctorRepository {
  DoctorRemoteDataSource dataSource;
  DoctorRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, Unit>> addDoctor(DoctorModel doctor) {
    return executeTryAndCatchForRepository(() {
      return dataSource.addDoctor(doctor);
    });
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File image) {
   return  executeTryAndCatchForRepository((){
      return dataSource.uploadProfilePicture(image);
    });
  }
  
  @override
Future<Either<Failure, DoctorModel?>> getDoctor(String uid) {
  return executeTryAndCatchForRepository(() async {
    final data = await dataSource.getDoctor(uid);
    return DoctorModel.fromMap(data) ;
  });
}

  @override
  Future<Either<Failure,DoctorModel >> addReview(Review review, double avgRate) {
    return executeTryAndCatchForRepository(() async {
      final response=await dataSource.addReview(review,avgRate);
      return DoctorModel.fromMap(response);
    });
  }
  
  @override
  Future<Either<Failure, void>> makeAppointment(DoctorAppointment appointment, String uid) {
    return executeTryAndCatchForRepository(() {
      return dataSource.makeAppointment(appointment, uid);
    });
  }
  
  @override
  Future<Either<Failure, List<DoctorAppointment>>> getDoctorAppointmentsAtDate(String doctorId, DateTime date) {
   return  executeTryAndCatchForRepository(() async {
      final response =await dataSource.getDoctorAppointmentsAtDate(doctorId, date);
      return response.map((e) => DoctorAppointment.fromMap(e)).toList();
    });
  }
  
  @override
  Future<Either<Failure, List<DoctorAppointment>>> getDoctorAppointments(String doctorId) {
    // TODO: implement getDoctorAppointments
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, DoctorModel?>> getDoctorById(String doctorId) {
    // TODO: implement getDoctorById
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> updateAppointmentStatus(String appointmentId, AppointmentStatus status) {
    // TODO: implement updateAppointmentStatus
    throw UnimplementedError();
  }
}
