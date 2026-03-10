import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/legal_repository.dart';
import 'legal_state.dart';

@injectable
class LegalCubit extends Cubit<LegalState> {
  final LegalRepository _repository;

  LegalCubit(this._repository) : super(LegalState(status: ViewStatus.initial));

  Future<void> loadTermsOfUse(String languageCode) async {
    emit(state.copyWith(status: ViewStatus.loading));
    try {
      final content = await _repository.getTermsOfUse(languageCode);
      emit(state.copyWith(status: ViewStatus.success, content: content));
    } catch (e) {
      emit(state.copyWith(
          status: ViewStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loadPrivacyPolicy(String languageCode) async {
    emit(state.copyWith(status: ViewStatus.loading));
    try {
      final content = await _repository.getPrivacyPolicy(languageCode);
      emit(state.copyWith(status: ViewStatus.success, content: content));
    } catch (e) {
      emit(state.copyWith(
          status: ViewStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loadRefundPolicy(String languageCode) async {
    emit(state.copyWith(status: ViewStatus.loading));
    try {
      final content = await _repository.getRefundPolicy(languageCode);
      emit(state.copyWith(status: ViewStatus.success, content: content));
    } catch (e) {
      emit(state.copyWith(
          status: ViewStatus.failure, errorMessage: e.toString()));
    }
  }
}
