import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/helpers/secure_storage_helper.dart';
import 'package:alagy/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@injectable
class AppUserCubit extends Cubit<AppUserState> {
  AuthRepository authRepository;
  AppUserCubit({required this.authRepository})
      : super(AppUserState(state: AppUserStates.initial));

  Future<void> saveUserData(
    UserModel? user,
  ) async {
    if (user != null) {
      final res = await SecureStorageHelper.saveUserData(user);
      res.fold((l) {
        emit(state.copyWith(
          state: AppUserStates.failureSaveData,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          state: AppUserStates.success,
          user: user,
        ));
      });
    }
  }

  Future<void> signOut() async {
    final res = await SecureStorageHelper.removeUserData();
    res.fold(
        (l) => emit(state.copyWith(
              state: AppUserStates.failure,
              errorMessage: 'Failed to sign out',
            )),
        (r) => emit(state.copyWith(
              state: AppUserStates.notLoggedIn,
              user: null,
            )));
  }

  Future<void> getUser({required String uid}) async {
    final result = await authRepository.getUser(uid: uid);
    result.fold(
        (l) => emit(state.copyWith(
              state: AppUserStates.failure,
              errorMessage: l.message,
            )), (r) {
      emit(state.copyWith(
        state: AppUserStates.gettedData,
        user: r,
      ));
    });
  }

  // Check if user is logged in
  void isUserLoggedIn() async {
    final res = await SecureStorageHelper.isUserLoggedIn();
    res.fold((l) {
      emit(state.copyWith(
        state: AppUserStates.notLoggedIn,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(state: AppUserStates.loggedIn, user: r));
    });
  }

  // Get stored user data
  void getStoredUserData() async {
    final res = await SecureStorageHelper.getUserData();
    res.fold(
        (l) => emit(state.copyWith(
              state: AppUserStates.failure,
              errorMessage: l,
            )),
        (r) => emit(state.copyWith(state: AppUserStates.loggedIn, user: r)));
  }

  Future<void> onSignOut() async {
    final res = await authRepository.signOut();
    res.fold(
        (l) => emit(state.copyWith(
              state: AppUserStates.failure,
              errorMessage: l.message,
            )),
        (r) => emit(state.copyWith(state: AppUserStates.signOut)));
  }



  void isFirstInstallation() async {
    final res = await SecureStorageHelper.isFirstInstallation();
    res.fold((l) {
      emit(state.copyWith(
        state: AppUserStates.notInstalled,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        state: AppUserStates.installed,
      ));
    });
  }

  void saveInstallationFlag() async {
    final res = await SecureStorageHelper.saveInstalltionFlag();
    res.fold((l) {
      emit(state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        state: AppUserStates.installed,
      ));
    });
  }

  void clearUserData() async {
    final res = await SecureStorageHelper.removeUserData();
    res.fold((l) {
      emit(state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        state: AppUserStates.clearUserData,
        user: null,
      ));
    });
 
}
 Future<void> updateUser (UserModel user,Map<String, dynamic> changedAttributes) async {
  emit(state.copyWith(
        state: AppUserStates.loading,
      ));
    final res = await authRepository.updateUser(user.uid, changedAttributes);
    res.fold((l) {
      emit(state.copyWith(
        state: AppUserStates.failure,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        state: AppUserStates.updated,
        user: user,
      ));
    });
  }

  bool isSpammer(){
    return state.user?.spamer??false;
  }
}