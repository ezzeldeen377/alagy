enum SearchStatus {
  initial,
  loading,
  success,
  error,
}
extension SearchStateX on SearchState {
  bool get isInitial => status == SearchStatus.initial;
  bool get isLoading => status == SearchStatus.loading;
  bool get isSuccess => status == SearchStatus.success;
  bool get isError => status == SearchStatus.error;
}

class SearchState {
  final SearchStatus status;
  final String query;
  final String? errorMessage;
  final List<dynamic> searchResults;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.errorMessage,
    this.searchResults = const [],
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    String? errorMessage,
    List<dynamic>? searchResults,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
