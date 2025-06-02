import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/data/datasources/home_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<DoctorModel>>> getVipDoctors();

  Future<Either<Failure, List<DoctorModel>>> getTopRatedDoctors();

  Future<Either<Failure, List<DoctorModel>>> getDoctorCategories(String category);

  Future<Either<Failure, List<DoctorModel>>> searchDoctors(String query);
  Future<Either<Failure,void>> addDoctorToFavourite(DoctorModel doctor, String userId);
  Future<Either<Failure,void>> removeDoctorFromFavourite(DoctorModel doctor, String userId);
  Stream<Either<Failure, List<String>>> getAllFavouriteDoctorId(String userId);
}
@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);
  
  @override
  Future<Either<Failure, List<DoctorModel>>> getDoctorCategories(String category) {
    return executeTryAndCatchForRepository(() async {
      final response=await dataSource.getDoctorCategories(category);
      return response.map((element)=>DoctorModel.fromMap(element)).toList();
    });
  }
  
  @override
  Future<Either<Failure, List<DoctorModel>>> getTopRatedDoctors() {
       return executeTryAndCatchForRepository(() async {
      final response=await dataSource.getTopRatedDoctors();
      return response.map((element)=>DoctorModel.fromMap(element)).toList();
    });
  }
  
  @override
  Future<Either<Failure, List<DoctorModel>>> getVipDoctors() {
       return executeTryAndCatchForRepository(() async {
      final response=await dataSource.getVipDoctors();
      return response.map((element)=>DoctorModel.fromMap(element)).toList();
    });
  }
  
  @override
  Future<Either<Failure, List<DoctorModel>>> searchDoctors(String query) {
   return executeTryAndCatchForRepository(() async {
      final response=await dataSource.searchDoctors(query);
      return response.map((element)=>DoctorModel.fromMap(element)).toList();
    });
  }
  
  @override
  Future<Either<Failure, void>> addDoctorToFavourite(DoctorModel doctor, String userId) {
   return executeTryAndCatchForRepository(() async {
      await dataSource.addDoctorToFavourite(doctor, userId);
    });
  }
  
  @override
  Future<Either<Failure, void>> removeDoctorFromFavourite(DoctorModel doctor, String userId) {
   return executeTryAndCatchForRepository(() async {
      await dataSource.removeDoctorFromFavourite(doctor, userId);
    
   });
  }
  
@override
Stream<Either<Failure, List<String>>> getAllFavouriteDoctorId(String userId) {
  return dataSource.getAllFavouriteDoctorId(userId).map<Either<Failure, List<String>>>(
    (list) => Right(list),
  ).handleError(
    (error) => Left(Failure(error.toString())),
  );
}

}