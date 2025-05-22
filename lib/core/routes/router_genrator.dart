import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/common/screens/initial_screen.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/utils/slide_page_route.dart';
import 'package:alagy/features/authentication/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:alagy/features/authentication/presentation/screens/forget_password.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/map/presentation/screens/select_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlagyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth routes
      case RouteNames.onboarding:
        return SlidePageRoute(
          page: const OnboardingScreen(),
        );
      case RouteNames.signIn:
        return SlidePageRoute(
          page: BlocProvider(
            create: (context) => getIt<SignInCubit>(),
            child: const SignInScreen(),
          ),
        );

      case RouteNames.signUp:
        return SlidePageRoute(
          page: BlocProvider(
            create: (context) => getIt<SignUpCubit>(),
            child: const SignUpScreen(),
          ),
        );
      // home screen routes
      case RouteNames.initial:
        return SlidePageRoute(page: const InitialScreen());

      // doctors screen
      case RouteNames.editDoctor:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<AddDoctorCubit>()
            ..getDoctorDetails((settings.arguments as UserModel).uid),
          child: const EditProfileScreen(),
        ));
      case RouteNames.forgetPassword:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<ForgetPasswordCubit>(),
          child: const ForgetPassword(),
        ));
      case RouteNames.selectLocationScreen:
        return SlidePageRoute(
            page: const SelectLocationScreen());

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text('Route "${settings.name ?? ''}" not found'),
                  ),
                ));
    }
  }
}
