import 'package:alagy/features/admin/data/models/admin_statistics.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/admin/data/repositories/admin_repository.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_state.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _adminRepository;

  AdminCubit(this._adminRepository) : super(const AdminState());

  Future<void> loadPendingDoctors() async {
    emit(state.copyWith(status: AdminStatus.loading));
    
    final result = await _adminRepository.getPendingDoctors();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: AdminStatus.success,
        pendingDoctors: doctors,
      )),
    );
  }

  Future<void> loadApprovedDoctors() async {
    emit(state.copyWith(status: AdminStatus.loading));
    
    final result = await _adminRepository.getApprovedDoctors();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: AdminStatus.success,
        approvedDoctors: doctors,
      )),
    );
  }

  Future<void> loadRejectedDoctors() async {
    emit(state.copyWith(status: AdminStatus.loading));
    
    final result = await _adminRepository.getRejectedDoctors();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: AdminStatus.success,
        rejectedDoctors: doctors,
      )),
    );
  }

  Future<void> loadStatistics([DateFilter? filter]) async {
    final dateFilter = filter ?? DateFilter.allTime;
    emit(state.copyWith(
      status: AdminStatus.loading,
      currentFilter: dateFilter,
    ));
    
    final result = await _adminRepository.getStatistics(dateFilter);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (statistics) => emit(state.copyWith(
        status: AdminStatus.success,
        statistics: statistics,
      )),
    );
  }

  void changeFilter(DateFilter filter) {
    if (state.currentFilter != filter) {
      loadStatistics(filter);
    }
  }

  Future<void> approveDoctor(String doctorId) async {
    emit(state.copyWith(status: AdminStatus.loading));
    
    final result = await _adminRepository.approveDoctor(doctorId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(status: AdminStatus.doctorApproved));
        // Reload pending doctors to update the list
        loadPendingDoctors();
      },
    );
  }

  Future<void> rejectDoctor(String doctorId) async {
    emit(state.copyWith(status: AdminStatus.loading));
    
    final result = await _adminRepository.rejectDoctor(doctorId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(status: AdminStatus.doctorRejected));
        // Reload pending doctors to update the list
        loadPendingDoctors();
      },
    );
  }
Future<void> toggleVipStatus(String doctorId, bool currentVipStatus) async {
  emit(state.copyWith(status: AdminStatus.loading));
  
  final result = await _adminRepository.updateDoctorVipStatus(doctorId, !currentVipStatus);
  result.fold(
    (failure) => emit(state.copyWith(
      status: AdminStatus.error,
      errorMessage: failure.message,
    )),
    (_) {
      emit(state.copyWith(status: AdminStatus.success));
      // Reload the appropriate doctor list to reflect changes
      loadApprovedDoctors();
    },
  );
}
  void clearError() {
    emit(state.copyWith(
      status: AdminStatus.initial,
      errorMessage: null,
    ));
  }
}