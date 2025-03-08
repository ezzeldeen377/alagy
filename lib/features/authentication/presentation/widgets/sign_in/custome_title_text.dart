import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeTitleText extends StatelessWidget {
  const CustomeTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 148.h, bottom: 65.h, left: 35.w, right: 35.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hello',
            style: TextStyle(fontSize: 50.sp,fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: Colors.white),
          ),
          Text(
            'Welcome To Pulse Max',
            style: TextStyle(fontSize: 16.sp,fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
