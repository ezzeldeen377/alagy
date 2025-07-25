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
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctors_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_page.dart';
import 'package:alagy/features/doctor/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/map/presentation/screens/select_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlagyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

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
        return SlidePageRoute(page: const SelectLocationScreen());
       case RouteNames.doctorPage:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<DoctorsCubit>()..getDoctors(args as String), // Change to DoctorsCubit
          child: const DoctorsPage(),
        ));
      case RouteNames.doctorDetails:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) =>
              getIt<DoctorDetailsCubit>()..passDoctor(args as DoctorModel)..changeDate(DateTime.now()),
          child: const DoctorDetailPage(),
        ));

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

class LoaderScreen extends StatefulWidget {
  final Future<void> Function()? loadFunction;
  final Widget child;
  final Widget? loadingWidget;

  const LoaderScreen({
    super.key,
    this.loadFunction,
    required this.child,
    this.loadingWidget,
  });

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.loadFunction != null) {
      widget.loadFunction!().then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.loadingWidget ??
          const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
    } else {
      return widget.child;
    }
  }
}
