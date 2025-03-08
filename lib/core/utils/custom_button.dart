import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomButton extends StatelessWidget {
 final String buttonText;
 final  void Function()? onTapButton;

  const CustomButton({super.key, required this.buttonText,required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTapButton,
        child: Container(
          height: 57.h,
          width: 305.w,
          decoration:  BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 119, 245, 245),
                AppColor.greenColor,
              ],),
              borderRadius: BorderRadius.circular(38.r),
          ),
          child: Center(
            child: Text(buttonText,
                style:  TextStyle(fontSize: 28.sp,fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: Colors.white),
          ),
       )),
      );
  }
}