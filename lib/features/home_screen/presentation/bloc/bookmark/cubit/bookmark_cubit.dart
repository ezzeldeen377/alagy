import 'dart:async';

import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'bookmark_state.dart';

@injectable
class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit(this.repository) : super(const BookmarkState());
  final HomeRepository repository;
  StreamSubscription? _streamSubscription;

  void getAllFavouriteDoctors(String userId) {
    // Cancel any existing subscription before creating a new one
    _streamSubscription?.cancel();
    
    _streamSubscription = repository.getAllFavouriteDoctors(userId).listen(
      (response) {
        response.fold(
          (failure) => emit(state.copyWith(errorMessage: failure.message)),
          (doctors) => emit(state.copyWith(bookmarkDoctors: doctors)),
        );
      },
      onError: (error) {
        emit(state.copyWith(errorMessage: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
