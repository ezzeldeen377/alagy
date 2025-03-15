import 'dart:io';

import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/datasources/doctor_remote_data_source.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

abstract class DoctorRepository {
  Future<Either<Failure, Unit>> addDoctor(DoctorModel doctor);
  Future<Either<Failure, String>> uploadProfilePicture(File image);
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
}
