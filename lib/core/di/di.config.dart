// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/authentication/data/data_source/auth_remote_data_source.dart'
    as _i21;
import '../../features/authentication/data/repositories/auth_repository.dart'
    as _i935;
import '../../features/authentication/presentation/cubits/forget_password_cubit/forget_password_cubit.dart'
    as _i158;
import '../../features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart'
    as _i670;
import '../../features/authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart'
    as _i531;
import '../../features/doctor/data/datasources/doctor_remote_data_source.dart'
    as _i59;
import '../../features/doctor/data/repositories/doctor_repository.dart'
    as _i611;
import '../../features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart'
    as _i708;
import '../../features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart'
    as _i54;
import '../../features/doctor/presentation/bloc/doctors_cubit.dart' as _i810;
import '../../features/home_screen/data/datasources/home_remote_data_source.dart'
    as _i5;
import '../../features/home_screen/data/repositories/home_repository.dart'
    as _i444;
import '../../features/home_screen/presentation/bloc/bookmark/cubit/bookmark_cubit.dart'
    as _i894;
import '../../features/home_screen/presentation/bloc/home_screen_cubit.dart'
    as _i1067;
import '../../features/settings/cubit/app_settings_cubit.dart' as _i50;
import '../common/cubit/app_user/app_user_cubit.dart' as _i94;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i50.AppSettingsCubit>(() => _i50.AppSettingsCubit());
    gh.factory<_i5.HomeRemoteDataSource>(() => _i5.HomeRemoteDataSourceImpl());
    gh.factory<_i59.DoctorRemoteDataSource>(
        () => _i59.DoctorRemoteDataSourceImpl());
    gh.factory<_i21.AuthRemoteDataSource>(
        () => _i21.AuthRemoteDataSourceImpl());
    gh.factory<_i444.HomeRepository>(
        () => _i444.HomeRepositoryImpl(gh<_i5.HomeRemoteDataSource>()));
    gh.factory<_i894.BookmarkCubit>(
        () => _i894.BookmarkCubit(gh<_i444.HomeRepository>()));
    gh.factory<_i935.AuthRepository>(() => _i935.AuthRepositoryImpl(
        authDataSource: gh<_i21.AuthRemoteDataSource>()));
    gh.factory<_i611.DoctorRepository>(() => _i611.DoctorRepositoryImpl(
        dataSource: gh<_i59.DoctorRemoteDataSource>()));
    gh.factory<_i810.DoctorsCubit>(
        () => _i810.DoctorsCubit(gh<_i444.HomeRepository>()));
    gh.factory<_i708.AddDoctorCubit>(
        () => _i708.AddDoctorCubit(repository: gh<_i611.DoctorRepository>()));
    gh.factory<_i158.ForgetPasswordCubit>(() =>
        _i158.ForgetPasswordCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i670.SignInCubit>(
        () => _i670.SignInCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i531.SignUpCubit>(
        () => _i531.SignUpCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i54.DoctorDetailsCubit>(
        () => _i54.DoctorDetailsCubit(gh<_i611.DoctorRepository>()));
    gh.factory<_i94.AppUserCubit>(() => _i94.AppUserCubit(
          authRepository: gh<_i935.AuthRepository>(),
          homeScreenRepository: gh<_i444.HomeRepository>(),
        ));
    gh.factory<_i1067.HomeScreenCubit>(() => _i1067.HomeScreenCubit(
          gh<_i611.DoctorRepository>(),
          gh<_i444.HomeRepository>(),
        ));
    return this;
  }
}
