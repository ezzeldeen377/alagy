import 'dart:async';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/helpers/secure_storage_helper.dart';
import 'package:alagy/features/authentication/data/repositories/auth_repository.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/data/repositories/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppUserCubit extends Cubit<AppUserState> {
  final AuthRepository authRepository;
  final HomeRepository homeScreenRepository;
  late StreamSubscription<User?>? authStateSubscription;
  bool _isInitialized = false; // Track if init has been called

  AppUserCubit(
      {required this.authRepository, required this.homeScreenRepository})
      : super(AppUserState(state: AppUserStates.initial));

  void init() {
    if (_isInitialized) {
      print('AppUserCubit already initialized, skipping init');
      return;
    }
    authStateSubscription =
        authRepository.authStateChanges.listen((user) async {
      if (user != null) {
        print("sign in success!!");
        emit(state.copyWith(state: AppUserStates.loggedIn, userId: user.uid));
      } else {
        print("sign out success??????");

        emit(state.copyWith(
          state: AppUserStates.notLoggedIn,
          user: null,
        ));
      }
    });
    _isInitialized = true;
  }

  void cancelAuthListener() {
    authStateSubscription?.cancel();
    authStateSubscription = null;
    _isInitialized = false;
  }
  void setUserId(String userId) {
    emit(state.copyWith(
      userId: userId,
    ));
  }
Future<void> updateNotificationToken(UserModel user, String? token) async {
  emit(state.copyWith(
    state: AppUserStates.loading,
  ));
  if(user.notificationToken == token&&token==null) return;
  final res = await authRepository.updateUser(
    user.uid,
    {'notificationToken': token},
  );

  res.fold(
    (failure) => emit(state.copyWith(
      state: AppUserStates.failure,
      errorMessage: failure.message,
    )),
    (success) => emit(state.copyWith(
      state: AppUserStates.updated,
    )),
  );
}
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
          userId: user.uid,
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
    emit(state.copyWith(state: AppUserStates.loading));
    final res = await SecureStorageHelper.isFirstInstallation();
    res.fold(
        (l) => emit(state.copyWith(
              state: AppUserStates.failure,
              errorMessage: l,
            )), (r) {
      if (r == null) {
        emit(state.copyWith(state: AppUserStates.notInstalled));
      } else {
        emit(state.copyWith(state: AppUserStates.installed));
      }
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

  Future<void> updateUser(
      UserModel user, Map<String, dynamic> changedAttributes) async {
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

  void getAllFavouriteDoctors(String userId) {
    homeScreenRepository.getAllFavouriteDoctorId(userId).listen(
      (response) {
        response.fold(
          (l) {
            emit(state.copyWith(
              errorMessage: l.message,
            ));
          },
          (r) {
            emit(state.copyWith(
              favouriteIds: r,
            ));
          },
        );
      },
      onError: (error) {
        emit(state.copyWith(
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> addDoctorToFavourite(DoctorModel doctor, String userId) async {
    await homeScreenRepository.addDoctorToFavourite(doctor, userId);
  }

  Future<void> removeDoctorFromFavourite(
      DoctorModel doctor, String userId) async {
    await homeScreenRepository.removeDoctorFromFavourite(doctor, userId);
  }

  @override
  Future<void> close() {
    print("cubit closssssssssssssssssssssssssssssssssed!!!!!!!!!!!!!!!");
    authStateSubscription?.cancel();
    return super.close();
  }
}
