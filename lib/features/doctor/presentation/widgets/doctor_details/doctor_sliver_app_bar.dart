import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/widgets/favourite_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DoctorSliverAppBar extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorSliverAppBar({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      floating: false,
      backgroundColor: AppColor.primaryColor,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.primaryColor,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        // Add to favorites button
        Padding(
          padding: EdgeInsets.all(8.r),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: FavoriteIcon(
              doctor: doctor,
              fromDetailsScreen: true,
            ),
          ),
        ),
        // Share button
        Padding(
          padding: EdgeInsets.all(8.r),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.share, color: AppColor.primaryColor),
              onPressed: () {
                // Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.doctorProfileShared),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
      
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
        doctor.name,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor,
              fontSize: 18.h
            ),
      ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Single image instead of carousel
            Container(
              width: MediaQuery.of(context).size.width,
          
              child: Hero(
                tag: 'doctor_image_${doctor.name}',
                child: ClipRRect(
                  child: SizedBox(
                    width: 100.w,
                    height: 150.h,
                    child: doctor.profileImage != null &&
                            doctor.profileImage!.startsWith("https")
                        ? CachedNetworkImage(
                            imageUrl: doctor.profileImage ?? '',
                            fit: BoxFit.cover,
                            memCacheHeight: (100.h *
                                    MediaQuery.of(context).devicePixelRatio)
                                .round(),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const SizedBox.shrink(),
                          )
                        : Image.asset(
                            doctor.profileImage ?? '',
                            width: 150.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
