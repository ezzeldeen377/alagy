part of 'bookmark_cubit.dart';
enum BookmarkStatus {
initial,
loading,
success,
failure,
}
extension BookmarkStateX on BookmarkState{
  bool get isInitial => status == BookmarkStatus.initial;
  bool get isLoading => status == BookmarkStatus.loading;
  bool get isSuccess => status == BookmarkStatus.success;
  bool get isFailure => status == BookmarkStatus.failure;

}
class BookmarkState {
  final BookmarkStatus status;
  final List<DoctorModel> bookmarkDoctors;
  final String? errorMessage;
  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarkDoctors = const [],
    this.errorMessage,
  });
  BookmarkState copyWith({
    BookmarkStatus? status,
    List<DoctorModel>? bookmarkDoctors,
    String? errorMessage,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarkDoctors: bookmarkDoctors ?? this.bookmarkDoctors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

