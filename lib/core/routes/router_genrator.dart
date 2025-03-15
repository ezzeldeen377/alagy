import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/common/screens/initial_screen.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:alagy/features/authentication/presentation/screens/on_boarding_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:alagy/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/pages/edit_doctor_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlagyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // Auth routes
      case RouteNames.onboarding:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      case RouteNames.signIn:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => getIt<SignInCubit>(),
            child: const SignInScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
      case RouteNames.signUp:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => getIt<SignUpCubit>(),
            child: const SignUpScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
        // home screen routes
              case RouteNames.initial:
        return MaterialPageRoute(builder: (context) => const InitialScreen());

        // doctors screen 
          case RouteNames.editDoctor:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => getIt<AddDoctorCubit>()..initState(settings.arguments as UserModel)..initControllers(),
                  child: const EditProfileScreen(),
                ));
//       case RouteNames.doctorsScreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<DoctorsCubit>()..getDoctorss((settings.arguments as String?)),
//                   child:  DoctorsScreen(startCategory: settings.arguments as String?,),
//                 ));
//       case RouteNames.doctorDetails:
//         final args = settings.arguments as DoctorModel;
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) => getIt<DoctorsCubit>(),
//             child: DoctorDetailsScreen(doctor: args),
//           ),
//         );
//       case RouteNames.chatScreen:
//         final args = settings.arguments as ChatModel;
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) {
//               final args = settings.arguments as ChatModel;
//               return getIt<ChatsCubit>()..listOnChatMessages(args.id!);
//             },
//             child: ChatScreen(chat: args),
//           ),
//         );
//       case RouteNames.userChats:
//         return MaterialPageRoute(
//             builder: (context) => BlocProvider(
//                   create: (context) => getIt<ChatsCubit>()
//                     ..getChats(context.read<AppUserCubit>().state.user!.uid!),
//                   child: const UserChatsScreen(),
//                 ));
//       case RouteNames.measurement:
//         return MaterialPageRoute(builder: (context) =>  MeasurementPage());

//     
//       case RouteNames.alarm:
//         return MaterialPageRoute(
//             builder: (context) =>  BlocProvider(
//   create: (context) => getIt<MedicineCubit>()..getMedicines(),
//   child: const AlarmPage(),
// ));
//       case RouteNames.askAi:
//         return MaterialPageRoute(
//             builder: (context) =>  BlocProvider(
//   create: (context) => getIt<AskAiCubit>(),
//   child: const AskAiScreen(),
// ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
