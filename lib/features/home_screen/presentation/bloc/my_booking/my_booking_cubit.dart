import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:alagy/features/home_screen/presentation/bloc/my_booking/my_booking_state';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyBookingCubit extends Cubit<MyBookingState> {
  MyBookingCubit(this.repository) : super(const MyBookingState());
  final HomeRepository repository;
  Future<void> getMyBookings(String userId) async {
    emit(state.copyWith(status: MyBookingStatus.loading));
    final result = await repository.getReservations(userId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: MyBookingStatus.error, errorMessage: failure.message)),
      (bookings) => emit(state.copyWith(
        status: MyBookingStatus.success,
        bookings: bookings,
      )),
    );
  }
}
