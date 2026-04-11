// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:alagy/core/common/enities/user_model.dart';

enum AppUserStates {
  initial,
  failure,
  notLoggedIn,
  loggedIn,
  signOut,
  installed,
  notInstalled,
  success,
  gettedData,
  failureSaveData,
  clearUserData,
  loading,
  getFavouriteDoctors,
  updated
}

extension AppUserStateExtension on AppUserState {
  bool  get isInitial => state == AppUserStates.initial;
  bool get isLoggedIn => state == AppUserStates.loggedIn;
  bool get isNotLoggedIn => state == AppUserStates.notLoggedIn;
  bool get isFailure => state == AppUserStates.failure;
  bool get isSignOut => state == AppUserStates.signOut;
  bool get isInstalled => state == AppUserStates.installed;
  bool get isNotInstalled => state == AppUserStates.notInstalled;
  bool get isSuccess => state == AppUserStates.success;
  bool get isGettedData => state == AppUserStates.gettedData;
  bool get isFailureSaveData => state == AppUserStates.failureSaveData;
  bool get isClearUserData => state == AppUserStates.clearUserData;
  bool get isLoading => state == AppUserStates.loading;
  bool get isUpdated => state == AppUserStates.updated;

  bool get isNotLogin => user == null;
}

class AppUserState {
  final AppUserStates state;
  final UserModel? user;
  final String? userId;
  final String? userIntialRoute;
  List<String>? favouriteIds;
  final String? errorMessage;
  AppUserState({
    required this.state,
    this.user,
    this.userIntialRoute,
    this.userId,
    this.favouriteIds=const[],
    this.errorMessage,
  });

  AppUserState copyWith({
    AppUserStates? state,
    UserModel? user,
    String? userIntialRoute,
    String? userId,
    List<String>? favouriteIds,
    String? errorMessage,
  }) {
    return AppUserState(
      state: state ?? this.state,
      user: user ?? this.user,
      userId: userId?? this.userId,
      userIntialRoute: userIntialRoute ?? this.userIntialRoute,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AppUserState(state: $state, user: $user, userIntialRoute: $userIntialRoute, favouriteIds: $favouriteIds, errorMessage: $errorMessage)';
  }

  
}
