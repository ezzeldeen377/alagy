import 'dart:async';

import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:alagy/features/home_screen/presentation/bloc/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@injectable
class SearchCubit extends Cubit<SearchState> {
  final HomeRepository homeRepository;
  SearchCubit({required this.homeRepository}) : super(const SearchState());
  final TextEditingController controller = TextEditingController();




void clearSearch() {
  controller.clear();
  focusNode.unfocus();
  emit(state.copyWith(
    status: SearchStatus.initial,
    searchResults: [],
  ));
}

void closeSearch(BuildContext context) {
  controller.clear();
  FocusScope.of(context).unfocus();
  emit(state.copyWith(
    status: SearchStatus.initial, 
    searchResults: [],
  ));
}
  final FocusNode focusNode = FocusNode();
  Timer? _debounce;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        getSearchDoctors(query);
      } else {
        emit(state.copyWith(
          status: SearchStatus.initial,
          searchResults: [],
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    controller.dispose();
    focusNode.dispose();
    return super.close();
  }
  Future<void> getSearchDoctors(String category) async {
    emit(state.copyWith(status: SearchStatus.loading));
    final response = await homeRepository.searchDoctors(category);
    response.fold((error) {
      emit(state.copyWith(
          status: SearchStatus.error, errorMessage: error.message));
    }, (doctors) {
      emit(
          state.copyWith(status: SearchStatus.success, searchResults: doctors));
    });
  }
}
