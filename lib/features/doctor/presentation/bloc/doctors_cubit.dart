import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:injectable/injectable.dart';
import 'doctor_state.dart';

@injectable
class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this._homeRepository) : super(const DoctorsState());
  final HomeRepository _homeRepository;
  Future<void> getDoctors(String category) async {
      emit(state.copyWith(
        status: DoctorsStatus.loading,
        error: null,
      ));

      final response = await _homeRepository.getDoctorCategories(category);
      response.fold(
          (l) => emit(
              state.copyWith(status: DoctorsStatus.failure, error: l.message,category: category)),
          (r) =>
              emit(state.copyWith(status: DoctorsStatus.success, doctors: r,category: category)));
   
  }

  void resetError() {
    emit(state.copyWith(
      error: null,
      status: DoctorsStatus.initial,
    ));
  }

  void reset() {
    emit(const DoctorsState());
  }
}
