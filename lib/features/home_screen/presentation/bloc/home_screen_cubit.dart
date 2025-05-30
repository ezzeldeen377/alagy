import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'home_screen_state.dart';

@injectable
class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit(this.doctorRepository, this.homeRepository)
      : super(const HomeScreenState());
  DoctorRepository doctorRepository;
  HomeRepository homeRepository;
  Future<void> addMultipleDoctors() async {
    emit(state.copyWith(status: HomeScreenStatus.loading));

    bool hasError = false;
    String? errorMsg;

    for (final doctor in DoctorFakeData.fakeDoctors) {
      final response = await doctorRepository.addDoctor(doctor);
      response.fold((error) {
        hasError = true;
        errorMsg = error.message;
      }, (_) {});
    }

    if (hasError) {
      emit(state.copyWith(
          status: HomeScreenStatus.error, errorMessage: errorMsg));
    } else {
      emit(state.copyWith(status: HomeScreenStatus.success));
    }
  }

  Future<void> getTopRatedDoctors() async {
    emit(state.copyWith(status: HomeScreenStatus.loadingTopRatedDoctor));
    final response = await homeRepository.getTopRatedDoctors();
    response.fold((error) {
      emit(state.copyWith(
          status: HomeScreenStatus.error,
          errorMessage: error.message));
    }, (doctors) {
      emit(state.copyWith(
          status: HomeScreenStatus.successTopRatedDoctor,
          topRatedDoctors: doctors));
    });
  }

  Future<void> getVipDoctors() async {
    emit(state.copyWith(status: HomeScreenStatus.loadingVipDoctor));
    final response = await homeRepository.getVipDoctors();
    response.fold((error) {
      emit(state.copyWith(
          status: HomeScreenStatus.error,
          errorMessage: error.message));
    }, (doctors) {
      emit(state.copyWith(
          status: HomeScreenStatus.successVipDoctor, vipDoctors: doctors));
    });
  }

  Future<void> getSearchDoctors(String category) async {
    emit(state.copyWith(status: HomeScreenStatus.loadingSearch));
    final response = await homeRepository.searchDoctors(category);
    response.fold((error) {
      emit(state.copyWith(
          status: HomeScreenStatus.error, errorMessage: error.message));
    }, (doctors) {
      emit(state.copyWith(
          status: HomeScreenStatus.successSearch, searchDoctors: doctors));
    });
  }
  Future<void> addDoctorToFavourite(DoctorModel doctor, String userId) async {
     final response =await homeRepository.addDoctorToFavourite(doctor, userId);
    response.fold((error) {
      emit(state.copyWith(
          status: HomeScreenStatus.error, errorMessage: error.message));
    }, (doctors) {
      emit(state.copyWith(
          status: HomeScreenStatus.success));
    });  }

  Future<void> removeDoctorFromFavourite(DoctorModel doctor, String userId) async {
     final response =await homeRepository.removeDoctorFromFavourite(doctor, userId);
    response.fold((error) {
      emit(state.copyWith(
          status: HomeScreenStatus.error, errorMessage: error.message));
    }, (doctors) {
      emit(state.copyWith(
          status: HomeScreenStatus.success));
    });
  }
}
