
enum ForgetPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ForgetPasswordState  {
  final ForgetPasswordStatus status;
  final String? errorMessage;
  final String? email;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.errorMessage,
    this.email,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? errorMessage,
    String? email,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }


}