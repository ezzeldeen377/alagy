import '../data/legal_model.dart';

enum ViewStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

class LegalState {
  final ViewStatus status;
  final LegalContent? content;
  final String? errorMessage;

  LegalState({
    required this.status,
    this.content,
    this.errorMessage,
  });

  LegalState copyWith({
    ViewStatus? status,
    LegalContent? content,
    String? errorMessage,
  }) {
    return LegalState(
      status: status ?? this.status,
      content: content ?? this.content,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
