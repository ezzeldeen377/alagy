


import 'package:alagy/core/common/enities/user_model.dart';

enum SignUpStatus {
  initial,
  loading,
  success,
  failure,
  visiblePassword,
  visiblePasswordConfirm,
  successSaveData,
  failureSaveData,
  successDeleteUser,
  failureDeleteUser,
  successSignOut,
  failureSignOut,
  checked,
  roleChanged
}

extension SignInStateExtension on SignUpState {
  bool get isInitial => state == SignUpStatus.initial;
  bool get isLoading => state == SignUpStatus.loading;
  bool get isSuccess => state == SignUpStatus.success;
  bool get isFailure => state == SignUpStatus.failure;
  bool get isVisiblePassword => state == SignUpStatus.visiblePassword;
  bool get isVisiblePasswordConfirm =>
      state == SignUpStatus.visiblePasswordConfirm;
  bool get isSuccessSaveData => state == SignUpStatus.successSaveData;
  bool get isFailureSaveData => state == SignUpStatus.failureSaveData;
  bool get isSuccessDeleteUser => state == SignUpStatus.successDeleteUser;
  bool get isFailureDeleteUser => state == SignUpStatus.failureDeleteUser;
  bool get isChecked => state == SignUpStatus.checked;
  bool get isRoleChanged =>  state== SignUpStatus.roleChanged;
}

class SignUpState {
  final SignUpStatus state;
  final UserModel? userModel;
  final String? erorrMessage;
  final bool isVisiblePassword;
  final bool isVisiblePasswordConfirm;
  final bool isChecked;
  final String role;
  SignUpState({
    required this.state,
    this.userModel,
    this.erorrMessage,
    this.isVisiblePassword = true,
    this.isVisiblePasswordConfirm = true,
    this.isChecked = false,
     this.role='patient',
  });

  SignUpState copyWith({
    SignUpStatus? state,
    UserModel? userModel,
    String? erorrMessage,
    bool? isVisiblePassword,
    bool? isVisiblePasswordConfirm,
    bool? isChecked,
    String? role,
  }) {
    return SignUpState(
      state: state ?? this.state,
      userModel: userModel ?? this.userModel,
      erorrMessage: erorrMessage ?? this.erorrMessage,
      isVisiblePassword: isVisiblePassword ?? this.isVisiblePassword,
      isVisiblePasswordConfirm: isVisiblePasswordConfirm ?? this.isVisiblePasswordConfirm,
      isChecked: isChecked ?? this.isChecked,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'SignUpState(state: $state, userModel: $userModel, erorrMessage: $erorrMessage, isVisiblePassword: $isVisiblePassword, isVisiblePasswordConfirm: $isVisiblePasswordConfirm, isChecked: $isChecked, role: $role)';
  }

}


