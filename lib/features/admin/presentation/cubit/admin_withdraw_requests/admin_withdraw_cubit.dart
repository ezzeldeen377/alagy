import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/admin/data/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'admin_withdraw_state.dart';

@injectable
class AdminWithdrawCubit extends Cubit<AdminWithdrawState> {
  final AdminRepository _adminRepository;

  AdminWithdrawCubit(this._adminRepository) : super(const AdminWithdrawState());

  void loadPendingRequests() async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _adminRepository.getPendingWithdrawRequests();

    result.fold(
      (l) => emit(
          state.copyWith(status: ViewStatus.failure, errorMessage: l.message)),
      (requests) =>
          emit(state.copyWith(status: ViewStatus.success, requests: requests)),
    );
  }

  void reviewRequest(String requestId, bool approved, String? adminNote,
      String userId, double amount) async {
    // Optimistic UI update or just show loading overlay? Let's use loading state.
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _adminRepository.reviewWithdrawRequest(
        requestId, approved, adminNote, userId, amount);

    result.fold(
      (l) => emit(
          state.copyWith(status: ViewStatus.failure, errorMessage: l.message)),
      (_) {
        // Remove the processed request from the list
        final updatedRequests =
            state.requests.where((r) => r.id != requestId).toList();
        emit(state.copyWith(
            status: ViewStatus.success, requests: updatedRequests));
      },
    );
  }
}
