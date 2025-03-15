import 'package:alagy/bloc_observer.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/global_l10n.dart';
import 'package:alagy/core/routes/router_genrator.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/settings/cubit/app_settings_state.dart';
import 'package:alagy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/core/theme/app_theme.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      BlocProvider(create: (context) => getIt<AppUserCubit>())
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
            title: 'Flutter Demo',
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
            home: BlocProvider(
              create: (context) => getIt<AddDoctorCubit>(),
              child: const OnboardingScreen(),
            ),
            onGenerateRoute: AlagyRouter.generateRoute,
          );
        },
      );
    });
  }
}
