import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_up_cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionWidget extends StatelessWidget {
  const RoleSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          print(state.role);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Patient selection box
              GestureDetector(
                onTap: () { 
                  print('clicked');
                  context
                    .read<SignUpCubit>()
                    .changeRole('patient');}, // Call parent function
                child: Container(
                  height: 50.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: state.role == 'patient'
                        ? const Color.fromRGBO(138, 73, 247, 1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Patient',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: state.role == 'patient'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              // Doctor selection box
              GestureDetector(
                onTap: () { 
                                    print('clicked2');

                  context
                    .read<SignUpCubit>()
                    .changeRole('doctor');}, // Call parent function
                child: Container(
                  height: 50.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color:  state.role == 'doctor'
                        ? const Color.fromRGBO(138, 73, 247, 1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Doctor',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color:  state.role == 'doctor'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
