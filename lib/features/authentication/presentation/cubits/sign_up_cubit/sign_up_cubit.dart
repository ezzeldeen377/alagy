import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/auth_repository.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String roleSelected='patient';
    SignUpCubit(
      {required  this.authRepository,})
        :super(SignUpState(state: SignUpStatus.initial));
  //init getPlaygrounds_from_firebase branch

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String type,
  }) async {
    emit(state.copyWith(state: SignUpStatus.loading));

    final result = await authRepository.signUp(
        email: email, password: password, name: name, type: type);

    result.fold(
      (l) {
        emit(state.copyWith(
        state: SignUpStatus.failure,
        erorrMessage: l.message,
      ));},
      (r) {

        emit(state.copyWith(
        state: SignUpStatus.success,
        userModel: r,
        erorrMessage:
            'Account created! Please check your email to verify your account before signing in.',
      ));},
    );
  }

  Future<void> setData({required UserModel userModel}) async {
    final result = await authRepository.setUser(userModel: userModel);
    result.fold((l) {
      emit(state.copyWith(
        state: SignUpStatus.failureSaveData,
        erorrMessage: l.message,
      ));
    },
        (r) => emit(state.copyWith(
              state: SignUpStatus.successSaveData,
            )));
  }

  Future<void> deleteUser({required String uid}) async {
    final result = await authRepository.deleteUser(uid: uid);
    result.fold(
        (l) => emit(state.copyWith(
              state: SignUpStatus.failureDeleteUser,
              erorrMessage: l.message,
            )),
        (r) => emit(state.copyWith(
              state: SignUpStatus.successDeleteUser,
            )));
  }

  Future<void> signOut() async {
    final result = await authRepository.signOut();
    result.fold(
        (l) => emit(state.copyWith(
              state: SignUpStatus.failureSignOut,
              erorrMessage: l.message,
            )),
        (r) => emit(state.copyWith(
              state: SignUpStatus.successSignOut,
            )));
  }

  changeVisiblePassword() {
    emit(state.copyWith(
        state: SignUpStatus.visiblePassword,
        isVisiblePassword: !state.isVisiblePassword));
  }

  changeVisibleConfirmPassword() {
    emit(state.copyWith(
        state: SignUpStatus.visiblePasswordConfirm,
        isVisiblePasswordConfirm: !state.isVisiblePasswordConfirm));
  }
  void check(bool value) {
  emit(state.copyWith(
    state: SignUpStatus.checked,
    isChecked: value, // Use the passed value directly
  ));
}
  // Future<void> sendVerificationEmail() async {
  //   await authRepository.sendVerificationEmail();
  // }
 void changeRole(String value) {
  if (state.role != value) { // Ensure state is actually changing
    emit(state.copyWith(role: value));
    print("New role emitted: $value");
  } else {
    print("Role is already ${state.role}. No state change.");
  }
}
}
