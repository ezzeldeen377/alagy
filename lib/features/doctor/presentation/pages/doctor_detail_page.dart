import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import '../../../home_screen/presentation/models/doctor_card_model.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorCardModel doctor;

  const DoctorDetailPage({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: AppColor.tealNew,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'doctor_image_${doctor.name}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  width: double.infinity,
                  height: 200.h,
                  child: doctor.imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: doctor.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColor.tealNew.withOpacity(0.1),
                            child: const Icon(Icons.person_rounded, size: 80),
                          ),
                        )
                      : Image.asset(
                          doctor.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColor.tealNew.withOpacity(0.1),
                            child: const Icon(Icons.person_rounded, size: 80),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              doctor.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
            ),
            Text(
              doctor.specialty,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 24.sp),
                SizedBox(width: 4.w),
                Text(
                  "${doctor.rating.toStringAsFixed(1)} (${doctor.reviewCount} reviews)",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.tealNew,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(context.l10n.bookNow),
            ),
          ],
        ),
      ),
    );
  }
}