import 'package:alagy/bloc_observer.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/screens/initial_screen.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/global_l10n.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:alagy/core/routes/router_genrator.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/settings/cubit/app_settings_state.dart';
import 'package:alagy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/core/theme/app_theme.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    timeago.setLocaleMessages('ar', timeago.ArMessages());

  await Supabase.initialize(
    url: 'https://tceseqtplmomxlregppm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjZXNlcXRwbG1vbXhscmVncHBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwMDY0NDgsImV4cCI6MjA1NzU4MjQ0OH0.5FvnbDL0YBVo4y1W9qlWKINO526-4cDcA7mLFE2j3eA',
  );
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
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
            title: 'Alagy',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              GlobalL10n.init(context); // Initialize here
              return child ?? const SizedBox();
            },
            home: BlocConsumer<AppUserCubit, AppUserState>(
              listener: (context, state) {
                if (state.isLoggedIn()) {
                  print("uid:${state.user?.uid}     ${state.userId}");
                  context.read<AppUserCubit>().getUser(uid: state.userId ?? "");
                  // context.read<AppUserCubit>().onSignOut();
                }
                if (state.isInstalled()) {
                  context.read<AppUserCubit>().init();
                }
                if (state.isClearUserData()) {
                  showSnackBar(context, "signout");
                }
              },
              builder: (context, state) {
                if (state.isLoading()) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(
                        child: CircularProgressIndicator(
                      
                    )),
                  );
                }
                if (state.isNotInstalled()) {
                  return const OnboardingScreen();
                }

                if (state.isSignOut() ||
                    state.isNotLoggedIn() ||
                    state.isClearUserData()) {
                  return BlocProvider(
                    create: (context) => getIt<SignInCubit>(),
                    child: const SignInScreen(),
                  );
                }

                if (state.isGettedData()) {
                  if (state.user?.type == "doctor") {
                    if (state.user?.isSaved ?? false) {
                      return const InitialScreen();
                    } else {
                      return BlocProvider(
                        create: (context) => getIt<AddDoctorCubit>()
                          ..getDoctorDetails(state.userId!),
                        child: const EditProfileScreen(),
                      );
                    }
                  }
                  return const InitialScreen();
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                      child: CircularProgressIndicator(
                    
                  )),
                );
              },
            ),
        
            onGenerateRoute: AlagyRouter.generateRoute,
          );
        },
      );
    });
  }
}
