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

import '../../features/admin/data/datasources/admin_remote_data_source.dart'
    as _i517;
import '../../features/admin/data/repositories/admin_repository.dart' as _i370;
import '../../features/admin/data/repositories/admin_repository_impl.dart'
    as _i335;
import '../../features/admin/presentation/cubit/admin_cubit.dart' as _i684;
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
import '../../features/discount/data/datasources/discount_code_remote_data_source.dart'
    as _i486;
import '../../features/discount/data/repositories/discount_code_repository.dart'
    as _i1019;
import '../../features/discount/presentation/cubit/discount_code_cubit.dart'
    as _i760;
import '../../features/doctor/data/datasources/doctor_dashboard_remote_data_source.dart'
    as _i191;
import '../../features/doctor/data/repositories/doctor_dashboard_repository.dart'
    as _i1041;
import '../../features/doctor/presentation/cubit/doctor_calendar_cubit.dart'
    as _i742;
import '../../features/doctor/presentation/cubit/doctor_dashboard_cubit.dart'
    as _i533;
import '../../features/doctor_details/data/datasources/doctor_remote_data_source.dart'
    as _i559;
import '../../features/doctor_details/data/repositories/doctor_repository.dart'
    as _i748;
import '../../features/doctor_details/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart'
    as _i239;
import '../../features/doctor_details/presentation/bloc/doctor_details/doctor_details_cubit.dart'
    as _i798;
import '../../features/doctor_details/presentation/bloc/doctors_cubit.dart'
    as _i703;
import '../../features/home_screen/data/datasources/home_remote_data_source.dart'
    as _i5;
import '../../features/home_screen/data/repositories/home_repository.dart'
    as _i444;
import '../../features/home_screen/presentation/bloc/bookmark/cubit/bookmark_cubit.dart'
    as _i894;
import '../../features/home_screen/presentation/bloc/home/home_screen_cubit.dart'
    as _i490;
import '../../features/home_screen/presentation/bloc/my_booking/my_booking_cubit.dart'
    as _i522;
import '../../features/home_screen/presentation/bloc/search/search_cubit.dart'
    as _i625;
import '../../features/legal/cubit/legal_cubit.dart' as _i860;
import '../../features/legal/data/legal_repository.dart' as _i1052;
import '../../features/payment/data/data_source/payment_data_source.dart'
    as _i846;
import '../../features/payment/data/repositories/payment_repository.dart'
    as _i75;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
import '../../features/payment/presentation/cubit/payment_history_cubit.dart'
    as _i423;
import '../../features/settings/cubit/app_settings_cubit.dart' as _i50;
import '../../features/settings/cubit/change_password_cubit.dart' as _i182;
import '../../features/settings/cubit/edit_profile_cubit.dart' as _i492;
import '../../features/settings/cubit/notification_cubit.dart' as _i947;
import '../../features/settings/data/datasources/notification_remote_data_source.dart'
    as _i194;
import '../../features/settings/data/repositories/notification_repository.dart'
    as _i701;
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
    gh.lazySingleton<_i1052.LegalRepository>(() => _i1052.LegalRepository());
    gh.factory<_i559.DoctorRemoteDataSource>(
        () => _i559.DoctorRemoteDataSourceImpl());
    gh.lazySingleton<_i517.AdminRemoteDataSource>(
        () => _i517.AdminRemoteDataSourceImpl());
    gh.factory<_i191.DoctorDashboardRemoteDataSource>(
        () => _i191.DoctorDashboardRemoteDataSourceImpl());
    gh.factory<_i194.NotificationRemoteDataSource>(
        () => _i194.NotificationRemoteDataSourceImpl());
    gh.factory<_i5.HomeRemoteDataSource>(() => _i5.HomeRemoteDataSourceImpl());
    gh.factory<_i846.PaymentRemoteDataSource>(
        () => _i846.PaymentRemoteDataSourceImpl());
    gh.factory<_i75.PaymentRepository>(() => _i75.PaymentRepositoryImpl(
        dataSource: gh<_i846.PaymentRemoteDataSource>()));
    gh.factory<_i21.AuthRemoteDataSource>(
        () => _i21.AuthRemoteDataSourceImpl());
    gh.factory<_i860.LegalCubit>(
        () => _i860.LegalCubit(gh<_i1052.LegalRepository>()));
    gh.factory<_i486.DiscountCodeRemoteDataSource>(
        () => _i486.DiscountCodeRemoteDataSourceImpl());
    gh.factory<_i748.DoctorRepository>(() => _i748.DoctorRepositoryImpl(
        dataSource: gh<_i559.DoctorRemoteDataSource>()));
    gh.lazySingleton<_i370.AdminRepository>(
        () => _i335.AdminRepositoryImpl(gh<_i517.AdminRemoteDataSource>()));
    gh.factory<_i444.HomeRepository>(
        () => _i444.HomeRepositoryImpl(gh<_i5.HomeRemoteDataSource>()));
    gh.factory<_i423.PaymentHistoryCubit>(
        () => _i423.PaymentHistoryCubit(gh<_i75.PaymentRepository>()));
    gh.factory<_i1041.DoctorDashboardRepository>(() =>
        _i1041.DoctorDashboardRepositoryImpl(
            gh<_i191.DoctorDashboardRemoteDataSource>()));
    gh.factory<_i533.DoctorDashboardCubit>(() =>
        _i533.DoctorDashboardCubit(gh<_i1041.DoctorDashboardRepository>()));
    gh.factory<_i239.AddDoctorCubit>(
        () => _i239.AddDoctorCubit(repository: gh<_i748.DoctorRepository>()));
    gh.factory<_i701.NotificationRepository>(() =>
        _i701.NotificationRepositoryImpl(
            gh<_i194.NotificationRemoteDataSource>()));
    gh.factory<_i894.BookmarkCubit>(
        () => _i894.BookmarkCubit(gh<_i444.HomeRepository>()));
    gh.factory<_i522.MyBookingCubit>(
        () => _i522.MyBookingCubit(gh<_i444.HomeRepository>()));
    gh.factory<_i490.HomeScreenCubit>(() => _i490.HomeScreenCubit(
          gh<_i748.DoctorRepository>(),
          gh<_i444.HomeRepository>(),
        ));
    gh.factory<_i1019.DiscountCodeRepository>(() =>
        _i1019.DiscountCodeRepositoryImpl(
            gh<_i486.DiscountCodeRemoteDataSource>()));
    gh.factory<_i935.AuthRepository>(() => _i935.AuthRepositoryImpl(
        authDataSource: gh<_i21.AuthRemoteDataSource>()));
    gh.factory<_i182.ChangePasswordCubit>(
        () => _i182.ChangePasswordCubit(gh<_i935.AuthRepository>()));
    gh.factory<_i703.DoctorsCubit>(
        () => _i703.DoctorsCubit(gh<_i444.HomeRepository>()));
    gh.factory<_i625.SearchCubit>(
        () => _i625.SearchCubit(homeRepository: gh<_i444.HomeRepository>()));
    gh.factory<_i513.PaymentCubit>(() => _i513.PaymentCubit(
          gh<_i748.DoctorRepository>(),
          gh<_i701.NotificationRepository>(),
          paymentRepository: gh<_i75.PaymentRepository>(),
        ));
    gh.factory<_i684.AdminCubit>(
        () => _i684.AdminCubit(gh<_i370.AdminRepository>()));
    gh.factory<_i742.DoctorCalendarCubit>(
        () => _i742.DoctorCalendarCubit(gh<_i748.DoctorRepository>()));
    gh.factory<_i798.DoctorDetailsCubit>(
        () => _i798.DoctorDetailsCubit(gh<_i748.DoctorRepository>()));
    gh.factory<_i158.ForgetPasswordCubit>(() =>
        _i158.ForgetPasswordCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i670.SignInCubit>(
        () => _i670.SignInCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i531.SignUpCubit>(
        () => _i531.SignUpCubit(authRepository: gh<_i935.AuthRepository>()));
    gh.factory<_i760.DiscountCodeCubit>(
        () => _i760.DiscountCodeCubit(gh<_i1019.DiscountCodeRepository>()));
    gh.factory<_i947.NotificationCubit>(
        () => _i947.NotificationCubit(gh<_i701.NotificationRepository>()));
    gh.factory<_i94.AppUserCubit>(() => _i94.AppUserCubit(
          authRepository: gh<_i935.AuthRepository>(),
          homeScreenRepository: gh<_i444.HomeRepository>(),
        ));
    gh.factory<_i492.EditProfileCubit>(() => _i492.EditProfileCubit(
          gh<_i748.DoctorRepository>(),
          authRepository: gh<_i935.AuthRepository>(),
          appUserCubit: gh<_i94.AppUserCubit>(),
        ));
    return this;
  }
}
