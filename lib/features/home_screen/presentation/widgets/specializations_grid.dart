import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpecializationsGrid extends StatelessWidget {
  const SpecializationsGrid({super.key});
 
  @override
  Widget build(BuildContext context) {
    final List<SpecializationModel> specializations = [
       SpecializationModel(
        title:AppConstants.vascularSurgery,
        iconPath: 'assets/icons/cardiologist.svg',
        color: Colors.red,
      ),
       SpecializationModel(
        title: AppConstants.dentistry,
        iconPath: 'assets/icons/dentail.svg',
        color: Colors.blue,
      ),
       SpecializationModel(
        title: AppConstants.internalMedicine,
        iconPath: 'assets/icons/general.svg',
        color: Colors.teal,
      ),
       SpecializationModel(
        title: AppConstants.ophthalmology,
        iconPath: 'assets/icons/lab.svg',
        color: Colors.purple,
      ),
       SpecializationModel(
        title: AppConstants.neurology,
        iconPath: 'assets/icons/neurology.svg',
        color: Colors.indigo,
      ),
       SpecializationModel(
        title: AppConstants.ivf,
        iconPath: 'assets/icons/pharmacy.svg',
        color: Colors.green,
      ),
       SpecializationModel(
        title:  AppConstants.chestDiseases,
        iconPath: 'assets/icons/pulmon.svg',
        color: Colors.blue,
      ),
       SpecializationModel(
        title: AppConstants.urology,
        iconPath: 'assets/icons/stomach.svg',
        color: Colors.orange,
      ),
    ];
    
    return SizedBox(
      height: 150.h, // Increased height for better visibility
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: specializations.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120.w, // Increased width for better spacing
            margin: EdgeInsets.only(right: 16.w), // Increased margin for better separation
            child: SpecializationCard(specialization: specializations[index]),
          );
        },
      ),
    );
  }
}

class SpecializationCard extends StatelessWidget {
  final SpecializationModel specialization;

  const SpecializationCard({
    super.key,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteNames.doctorPage, arguments: specialization.title);
      },
      child: Card(
        elevation: 5,
        shadowColor: context.isDark ? Colors.blueGrey.withOpacity(0.1) : Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.r), // Increased padding
              margin: EdgeInsets.all(10.r), // Increased margin
              decoration: BoxDecoration(
                color: specialization.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                specialization.iconPath,
                width: 32.w, // Increased icon size
                height: 32.h, // Increased icon size
                colorFilter: ColorFilter.mode(
                  specialization.color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              context.getSpecialty(specialization.title),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp, // Increased font size
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h), // Increased bottom spacing
          ],
        ),
      ),
    );
  }
}

class SpecializationModel {
  final String title;
  final String iconPath;
  final Color color;

  const SpecializationModel({
    required this.title,
    required this.iconPath,
    required this.color,
  });
}