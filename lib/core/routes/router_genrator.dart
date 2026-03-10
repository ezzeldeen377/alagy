import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/common/screens/initial_screen.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/utils/slide_page_route.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:alagy/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:alagy/features/authentication/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:alagy/features/authentication/presentation/screens/forget_password.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_home_screen.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctors_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/doctor_details/presentation/pages/doctor_page.dart';
import 'package:alagy/features/doctor_details/presentation/pages/edit_doctor_details.dart';
import 'package:alagy/features/map/presentation/screens/select_location_screen.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:alagy/features/payment/presentation/screens/select_payment_option.dart';
import 'package:alagy/features/settings/cubit/edit_profile_cubit.dart';
import 'package:alagy/features/settings/presentation/edit_profile_screen.dart';
import 'package:alagy/features/settings/presentation/notifications_screen.dart';
import 'package:alagy/features/settings/presentation/profile_screen.dart';
import '../../features/legal/presentation/legal_screen.dart';
import 'package:alagy/features/categories/presentation/pages/categories_screen.dart';
import 'package:alagy/features/payment/presentation/screens/payment_history_screen.dart';
import 'package:alagy/features/settings/presentation/pages/change_password_screen.dart';
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
            child: SignInScreen(
              canClose: settings.arguments is bool
                  ? settings.arguments as bool
                  : false,
            ),
          ),
        );

      case RouteNames.signUp:
        return SlidePageRoute(
          page: BlocProvider(
            create: (context) => getIt<SignUpCubit>(),
            child: SignUpScreen(
              canClose: settings.arguments is bool
                  ? settings.arguments as bool
                  : false,
            ),
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
          child: const EditDoctorProfileScreen(),
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
          create: (context) => getIt<DoctorsCubit>()
            ..getDoctors(args as String?), // Change to DoctorsCubit
          child: const DoctorsPage(),
        ));
      case RouteNames.admin:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<AdminCubit>(), // Change to DoctorsCubit
          child: const AdminDashboardScreen(),
        ));

      case RouteNames.doctorDetails:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<DoctorDetailsCubit>()
            ..passDoctor(args as DoctorModel)
            ..changeDate(DateTime.now()),
          child: const DoctorDetailPage(),
        ));
      case RouteNames.selectPayment:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<PaymentCubit>()
            ..initAppointment(
              settings.arguments as DoctorAppointment,
            ),
          child: const SelectPaymentOption(),
        ));
      case RouteNames.notifications:
        return SlidePageRoute(page: const NotificationsScreen());
      case RouteNames.editProfile:
        return SlidePageRoute(
          page: BlocProvider(
            create: (context) => getIt<EditProfileCubit>(),
            child: const EditProfileScreen(),
          ),
        );

      case RouteNames.doctorHome:
        return SlidePageRoute(
            page: BlocProvider(
          create: (context) => getIt<DoctorDashboardCubit>(),
          child: const DoctorHomeScreen(),
        ));
      case RouteNames.profile:
        return SlidePageRoute(page: const ProfileScreen());
      case RouteNames.termsOfUse:
        return SlidePageRoute(
            page: const LegalScreen(type: LegalType.termsOfUse));
      case RouteNames.privacyPolicy:
        return SlidePageRoute(
            page: const LegalScreen(type: LegalType.privacyPolicy));
      case RouteNames.refundPolicy:
        return SlidePageRoute(
            page: const LegalScreen(type: LegalType.refundPolicy));
      case RouteNames.categories:
        return SlidePageRoute(page: const CategoriesScreen());
      case RouteNames.paymentHistory:
        return SlidePageRoute(page: const PaymentHistoryScreen());
      case RouteNames.changePassword:
        return SlidePageRoute(page: const ChangePasswordScreen());
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
