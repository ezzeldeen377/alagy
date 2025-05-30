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
  bool isInitial() => state == AppUserStates.initial;
  bool isLoggedIn() => state == AppUserStates.loggedIn;
  bool isNotLoggedIn() => state == AppUserStates.notLoggedIn;
  bool isFailure() => state == AppUserStates.failure;
  bool isSignOut() => state == AppUserStates.signOut;
  bool isInstalled() => state == AppUserStates.installed;
  bool isNotInstalled() => state == AppUserStates.notInstalled;
  bool isSuccess() => state == AppUserStates.success;
  bool isGettedData() => state == AppUserStates.gettedData;
  bool isFailureSaveData() => state == AppUserStates.failureSaveData;
  bool isClearUserData() => state == AppUserStates.clearUserData;
  bool isLoading() => state == AppUserStates.loading;
  bool isUpdated() => state == AppUserStates.updated;
}

class AppUserState {
  final AppUserStates state;
  final UserModel? user;
  final String? userIntialRoute;
  final String? userId;
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
      userIntialRoute: userIntialRoute ?? this.userIntialRoute,
      userId: userId ?? this.userId,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AppUserState(state: $state, user: $user, userIntialRoute: $userIntialRoute, userId: $userId, favouriteIds: $favouriteIds, errorMessage: $errorMessage)';
  }

  
}
