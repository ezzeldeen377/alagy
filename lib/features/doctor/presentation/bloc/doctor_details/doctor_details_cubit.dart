import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'doctor_details_state.dart';

@injectable
class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final DoctorRepository _doctorRepository;

  DoctorDetailsCubit(this._doctorRepository) : super(const DoctorDetailsState());
  final ratingCommentController = TextEditingController();
  final GlobalKey<FormState> ratingFormKey = GlobalKey<FormState>();
  final GlobalKey targetKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  void passDoctor(DoctorModel doctor) {
    emit(state.copyWith(selectedDoctor: doctor));
  }
  void selectRating(int rating) {
    emit(state.copyWith(userRate: rating));
  }
  Future<void> addReview(Review review) async {
    setLoading();
    final response=await _doctorRepository.addReview(review, state.selectedDoctor!.rating??0);
    response.fold((l) => setError(l.message), (r) {
      setSuccess(doctor: r);
    });
  }
  void reset() {
    emit(const DoctorDetailsState());
  }

  void setError(String message) {
    emit(state.copyWith(
      status: DoctorDetailsStatus.error,
      errorMessage: message,
    ));
  }

  void setLoading() {
    emit(state.copyWith(status: DoctorDetailsStatus.loading));
  }

  void setSuccess({DoctorModel? doctor}) {
    emit(state.copyWith(status: DoctorDetailsStatus.success,selectedDoctor: doctor));
  }
}