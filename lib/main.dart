import 'package:alagy/bloc_observer.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/screens/initial_screen.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/global_l10n.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:alagy/core/routes/router_genrator.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_home_screen.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/settings/cubit/app_settings_state.dart';
import 'package:alagy/firebase_options.dart';
import 'package:alagy/test.dart';
// Add these imports for admin functionality
import 'package:alagy/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:alagy/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/core/theme/app_theme.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  NotificationService.instance.initialize();
  NotificationService.instance.setupFlutterNotifications();

  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  // Initialize admin module
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<AppSettingsCubit>()),
      BlocProvider(
          create: (context) => getIt<AppUserCubit>()..isFirstInstallation())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
      return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Rosheta',
            themeAnimationCurve: Curves.easeInOutCubic,
            themeAnimationDuration: Duration(milliseconds: 400),
            themeAnimationStyle: AnimationStyle.noAnimation,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            builder: (context, child) {
              GlobalL10n.init(context);

              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: child,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.98, end: 1.0)
                            .animate(animation),
                        child: child,
                      ),
                    );
                  });
            },
            home: BlocConsumer<AppUserCubit, AppUserState>(
              listener: (context, state) async {
                if (state.isLoggedIn) {
                  await context
                      .read<AppUserCubit>()
                      .getUser(uid: state.userId!);
                }
                if (state.isInstalled) {
                  context.read<AppUserCubit>().init();
                }
                if (state.isClearUserData) {
                  showSnackBar(context, context.l10n.signout);
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.isNotInstalled) {
                  return const OnboardingScreen();
                }
                if (state.isNotLoggedIn) {
                  return const InitialScreen();
                }
                if (state.isSignOut || state.isClearUserData) {
                  return BlocProvider(
                    create: (context) => getIt<SignInCubit>(),
                    child: const SignInScreen(),
                  );
                }

                if (state.isGettedData) {
                  if (state.user?.type == "admin") {
                    return BlocProvider(
                      create: (context) => getIt<AdminCubit>(),
                      child: const AdminDashboardScreen(),
                    );
                  }
                  if (state.user?.type == "doctor") {
                    if (state.user?.isSaved ?? false) {
                      return BlocProvider(
                        create: (context) => getIt<DoctorDashboardCubit>(),
                        child: const DoctorHomeScreen(),
                      );
                    } else {
                      return BlocProvider(
                        create: (context) => getIt<AddDoctorCubit>()
                          ..getDoctorDetails(state.user?.uid ?? ""),
                        child: const EditDoctorProfileScreen(),
                      );
                    }
                  }
                  return const InitialScreen();
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: AlagyRouter.generateRoute,
          );
        },
      );
    });
  }
}
