// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:alagy/core/common/enities/user_model.dart';

enum SignInStatus {
  initial,
  loading,
  success,
  failure,
  visible,
  successGetData,
  failureGetData,
  successSignOut,
  googleAuthLoading,
  googleAuthSuccess,
  googleAuthFailure,
  setUserDataSuccess,
  setUserDataLoading,
  setUserDataFailure,
  successSignIn,
  failureSignIn,
  isAlreadySignIn,
  isNotSignIn,
}

extension SignInStateExtension on SignInState {
  bool get isInitial => state == SignInStatus.initial;
  bool get isLoading => state == SignInStatus.loading;
  bool get isSuccess => state == SignInStatus.success;
  bool get isFailure => state == SignInStatus.failure;
  bool get isVisible => state == SignInStatus.visible;
  bool get isSuccessGetData => state == SignInStatus.successGetData;
  bool get isFailureGetData => state == SignInStatus.failureGetData;
  bool get isSuccessSignOut => state == SignInStatus.successSignOut;
  bool get isGoogleAuthLoading => state == SignInStatus.googleAuthLoading;
  bool get isGoogleAuthSuccess => state == SignInStatus.googleAuthSuccess;
  bool get isGoogleAuthFailure => state == SignInStatus.googleAuthFailure;
  bool get isSetUserDataLoading => state == SignInStatus.setUserDataLoading;
  bool get isSetUserDataSuccess => state == SignInStatus.setUserDataSuccess;
  bool get isSetUserDataFaliure => state == SignInStatus.setUserDataFailure;
  bool get isSuccessSignIn => state == SignInStatus.successSignIn;
  bool get isFailureSignIn => state == SignInStatus.failureSignIn;
  bool get isAlreadySignIn => state == SignInStatus.isAlreadySignIn;
  bool get isNotSignIn => state == SignInStatus.isNotSignIn;
}

class SignInState {
  final SignInStatus state;
  final UserModel? userModel;
  final String? erorrMessage;
  final String? email;
  final String? password;
  final String? uid;
  final bool isVisible;
  SignInState({
    required this.state,
    this.userModel,
    this.erorrMessage,
    this.uid,
    this.isVisible = true,
    this.email,
    this.password,
  });

  SignInState copyWith({
    SignInStatus? state,
    UserModel? userModel,
    String? erorrMessage,
    bool? isVisible,
    String? uid,
    String? email,
    String? password,
  }) {
    return SignInState(
      state: state ?? this.state,
      userModel: userModel ?? this.userModel,
      erorrMessage: erorrMessage ?? this.erorrMessage,
      isVisible: isVisible ?? this.isVisible,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() =>
      'SignInState(state: $state, userModel: $userModel, erorrMessage: $erorrMessage isVisible: $isVisible uid: $uid email: $email password: $password)';

  @override
  bool operator ==(covariant SignInState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.userModel == userModel &&
        other.erorrMessage == erorrMessage &&
        other.isVisible == isVisible &&
        other.uid == uid &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode =>
      state.hashCode ^
      userModel.hashCode ^
      erorrMessage.hashCode ^
      isVisible.hashCode ^
      uid.hashCode ^
      email.hashCode ^
      password.hashCode;
}
