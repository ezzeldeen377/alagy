import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
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
      backgroundColor: AppColor.tealNew,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            child: IconButton(
              icon: Icon(
                doctor.isSaved == true ? Icons.favorite : Icons.favorite_border,
                color: doctor.isSaved == true ? Colors.red : Colors.white,
              ),
              onPressed: () {
                // Implement save/favorite functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(doctor.isSaved == true
                        ? context.l10n.removedFromFavorites
                        : context.l10n.addedToFavorites),
                    backgroundColor: AppColor.tealNew,
                  ),
                );
              },
            ),
          ),
        ),
        // Share button
        Padding(
          padding: EdgeInsets.all(8.r),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.doctorProfileShared),
                    backgroundColor: AppColor.tealNew,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
      
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Single image instead of carousel
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColor.tealNew.withOpacity(0.1),
              ),
              child:Hero(
                      tag: 'doctor_image_${doctor.name}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: SizedBox(
                          width: 100.w,
                          height: 150.h,
                          child: doctor.profileImage!=null&&doctor.profileImage!.startsWith("https")
                              ? CachedNetworkImage(
                                  imageUrl: doctor.profileImage??'',
                                  fit: BoxFit.cover,
                                  memCacheHeight: (100.h *
                                          MediaQuery.of(context)
                                              .devicePixelRatio)
                                      .round(),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SizedBox.shrink(),
                                )
                              : Image.asset(
                                  doctor.profileImage??'',
                                  width: 150.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                    SizedBox.shrink(),
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
