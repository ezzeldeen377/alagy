// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alagy/features/doctor/data/models/doctor_model.dart';

enum HomeScreenStatus {
  initial,
  loading,
  loadingSearch,
  loadingTopRatedDoctor,
  loadingVipDoctor,
  success,
  successTopRatedDoctor,
  successVipDoctor,
  successSearch,
  error,
  errorTopRatedDoctor,
  errorVipDoctor,
  errorSearch,
}
extension HomeScreenStatusX on HomeScreenState {
  bool get isInitial => status == HomeScreenStatus.initial;
  bool get isLoading => status == HomeScreenStatus.loading;
  bool get isLoadingSearch => status == HomeScreenStatus.loadingSearch;
  bool get isLoadingTopRatedDoctor =>
      status == HomeScreenStatus.loadingTopRatedDoctor;
  bool get isLoadingVipDoctor => status == HomeScreenStatus.loadingVipDoctor;

  bool get isSuccess => status == HomeScreenStatus.success;
  bool get isSuccessTopRatedDoctor =>
      status == HomeScreenStatus.successTopRatedDoctor;
  bool get isSuccessVipDoctor => status == HomeScreenStatus.successVipDoctor;
  bool get isSuccessSearch => status == HomeScreenStatus.successSearch;

  bool get isError => status == HomeScreenStatus.error;
  bool get isErrorTopRatedDoctor =>
      status == HomeScreenStatus.errorTopRatedDoctor;
  bool get isErrorVipDoctor => status == HomeScreenStatus.errorVipDoctor;
  bool get isErrorSearch => status == HomeScreenStatus.errorSearch;
  bool get isAllLoaded =>topRateddoctors != null && vipdoctors != null;

}


class HomeScreenState {
  final HomeScreenStatus status;
  final String? errorMessage;
  final List<DoctorModel>? topRateddoctors;
  final List<DoctorModel>? searchDoctors;
  final List<DoctorModel>? vipdoctors;
  

  const HomeScreenState({
    this.status = HomeScreenStatus.initial,
    this.errorMessage,
    this.topRateddoctors,
    this.searchDoctors,
    this.vipdoctors,
  });

  HomeScreenState copyWith({
    HomeScreenStatus? status,
    String? errorMessage,
    List<DoctorModel>? topRatedDoctors,
    List<DoctorModel>? searchDoctors,
    List<DoctorModel>? vipDoctors,
  }) {
    return HomeScreenState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      topRateddoctors: topRatedDoctors ?? this.topRateddoctors,
      searchDoctors: searchDoctors ?? this.searchDoctors,
      vipdoctors: vipDoctors ?? this.vipdoctors,
    );
  }

  @override
  String toString() {
    return 'HomeScreenState(status: $status, errorMessage: $errorMessage, searchDoctors: $searchDoctors, )';
  }
}
