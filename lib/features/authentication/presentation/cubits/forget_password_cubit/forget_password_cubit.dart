import 'package:alagy/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'forget_password_state.dart';
@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _authRepository;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgetPasswordCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const ForgetPasswordState());

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(
      status: ForgetPasswordStatus.loading,
      errorMessage: null,
    ));

    try {
      final email = emailController.text.trim();
      await _authRepository.resetPassword(email:  email);
      
      emit(state.copyWith(
        status: ForgetPasswordStatus.success,
        email: email,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void resetState() {
    emit(const ForgetPasswordState());
  }
}