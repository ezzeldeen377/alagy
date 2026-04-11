import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.specializations,
            style: TextStyle(
              color: AppColor.whiteColor,
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.85,
          ),
          itemCount: AppConstants.specialtiesKeys.length,
          itemBuilder: (context, index) {
            final specialtyKey = AppConstants.specialtiesKeys[index];
            return CategoryCard(specialtyKey: specialtyKey);
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String specialtyKey;

  const CategoryCard({
    super.key,
    required this.specialtyKey,
  });

  String _getLocalizedSpecialty(BuildContext context, String key) {
    switch (key) {
      case 'internalMedicine':
        return context.l10n.internalMedicine;
      case 'vascularSurgery':
        return context.l10n.vascularSurgery;
      case 'orthopedics':
        return context.l10n.orthopedics;
      case 'specializations':
        return context.l10n.specializations;
      case 'gynecologyAndObstetrics':
        return context.l10n.gynecologyAndObstetrics;
      case 'pediatricsAndNeonatology':
        return context.l10n.pediatricsAndNeonatology;
      case 'urology':
        return context.l10n.urology;
      case 'dentistry':
        return context.l10n.dentistry;
      case 'neurology':
        return context.l10n.neurology;
      case 'cosmeticSurgery':
        return context.l10n.cosmeticSurgery;
      case 'ophthalmology':
        return context.l10n.ophthalmology;
      case 'ent':
        return context.l10n.ent;
      case 'chestDiseases':
        return context.l10n.chestDiseases;
      case 'dermatology':
        return context.l10n.dermatology;
      case 'physiotherapy':
        return context.l10n.physiotherapy;
      case 'ivf':
        return context.l10n.ivf;
      case 'speechAndLanguageTherapy':
        return context.l10n.speechAndLanguageTherapy;
      default:
        return key;
    }
  }

  IconData _getSpecialtyIcon(String key) {
    switch (key) {
      case 'internalMedicine':
        return Icons.medical_services;
      case 'vascularSurgery':
        return Icons.favorite;
      case 'orthopedics':
        return Icons.accessibility_new;
      case 'gynecologyAndObstetrics':
        return Icons.pregnant_woman;
      case 'pediatricsAndNeonatology':
        return Icons.child_care;
      case 'urology':
        return Icons.water_drop;
      case 'dentistry':
        return Icons.local_hospital;
      case 'neurology':
        return Icons.psychology;
      case 'cosmeticSurgery':
        return Icons.face_retouching_natural;
      case 'ophthalmology':
        return Icons.visibility;
      case 'ent':
        return Icons.hearing;
      case 'chestDiseases':
        return Icons.air;
      case 'dermatology':
        return Icons.face;
      case 'physiotherapy':
        return Icons.fitness_center;
      case 'ivf':
        return Icons.science;
      case 'speechAndLanguageTherapy':
        return Icons.record_voice_over;
      default:
        return Icons.local_hospital;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to doctors list filtered by this specialty
        Navigator.pushNamed(context, RouteNames.doctorPage,
            arguments: specialtyKey);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getSpecialtyIcon(specialtyKey),
                color: Theme.of(context).primaryColor,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                _getLocalizedSpecialty(context, specialtyKey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
