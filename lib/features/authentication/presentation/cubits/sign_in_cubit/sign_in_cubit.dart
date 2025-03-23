import 'package:alagy/core/common/enities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/auth_repository.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthRepository authRepository;
  SignInCubit({
    required this.authRepository,
  }) : super(SignInState(state: SignInStatus.initial));
  //init getPlaygrounds_from_firebase branch

  Future<void> signIn() async {
    emit(state.copyWith(state: SignInStatus.loading));
    final result = await authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    result.fold((l) {
      emit(state.copyWith(
        state: SignInStatus.failure,
        erorrMessage: l.message,
      ));
    }, (r) {});
  }

  Future<void> getUser({required String uid}) async {
    final result = await authRepository.getUser(uid: uid);
    result.fold(
        (l) => emit(state.copyWith(
              state: SignInStatus.failureGetData,
              erorrMessage: l.message,
            )),
        (r) => emit(state.copyWith(
              state: SignInStatus.successGetData,
              userModel: r,
            )));
  }

  // Save user data securely

  Future<void> signOut() async {
    final res = await authRepository.signOut();
    res.fold(
        (l) => emit(state.copyWith(
              state: SignInStatus.failure,
              erorrMessage: l.message,
            )),
        (r) => emit(state.copyWith(state: SignInStatus.successSignOut)));
  }

  // Sign out and clear secure storage

  changeVisiblePassword() {
    emit(state.copyWith(
        state: SignInStatus.visible, isVisible: !state.isVisible));
  }

  Future<void> googleAuth() async {
    emit(state.copyWith(
      state: SignInStatus.googleAuthLoading,
    ));
    final result = await authRepository.googleAuth();
    result.fold((error) {
      emit(state.copyWith(
          state: SignInStatus.googleAuthFailure,
          erorrMessage: state.erorrMessage));
    }, (userData)  {
    });
  }

  Future<void> setUserData({required UserModel userModel}) async {
    emit(state.copyWith(
      state: SignInStatus.setUserDataLoading,
    ));
    final result = await authRepository.setUser(userModel: userModel);
    result.fold(
        (l) => emit(state.copyWith(
              state: SignInStatus.setUserDataFailure,
              erorrMessage: l.message,
            )),
        (r) => emit(state.copyWith(
              state: SignInStatus.setUserDataSuccess,
            )));
  }

  // Future<void> checkUesrSignin(
  //     {required String email, required String password}) async {
  //   final result = await authRepository.checkUesrSignin();
  //   result.fold((error) {
  //     emit(state.copyWith(
  //         state: SignInStatus.isAlreadySignIn,
  //         email: email,
  //         password: password,
  //         erorrMessage: state.erorrMessage));
  //   }, (userData) {
  //     if (userData) {
  //       emit(state.copyWith(
  //           state: SignInStatus.isAlreadySignIn,
  //           email: email,
  //           password: password));
  //     } else {
  //       emit(state.copyWith(
  //           state: SignInStatus.isNotSignIn, email: email, password: password));
  //     }
  //   });
  // }
}
