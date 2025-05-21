import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DoctorCardSlider extends StatefulWidget {
  const DoctorCardSlider({Key? key}) : super(key: key);

  @override
  State<DoctorCardSlider> createState() => _DoctorCardSliderState();
}

class _DoctorCardSliderState extends State<DoctorCardSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentPage = 0;

  final List<DoctorCardModel> _doctors = [
    DoctorCardModel(
      name: "Dr. Sarah Johnson",
      specialty: "Cardiologist",
      rating: 4.8,
      reviewCount: 124,
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    ),
    DoctorCardModel(
      name: "Dr. Michael Chen",
      specialty: "Neurologist",
      rating: 4.7,
      reviewCount: 98,
      imageUrl: "assets/images/doctor_image.png",
    ),
    DoctorCardModel(
      name: "Dr. Aisha Rahman",
      specialty: "Pediatrician",
      rating: 4.9,
      reviewCount: 156,
      imageUrl: "assets/images/doctor_image.png",
    ),
    DoctorCardModel(
      name: "Dr. James Wilson",
      specialty: "Dermatologist",
      rating: 4.6,
      reviewCount: 87,
      imageUrl: "assets/images/doctor_image.png",
    ),
    DoctorCardModel(
      name: "Dr. Maria Garcia",
      specialty: "Orthopedic Surgeon",
      rating: 4.9,
      reviewCount: 142,
      imageUrl: "assets/images/doctor_image.png",
    ),
    DoctorCardModel(
      name: "Dr. Robert Taylor",
      specialty: "Ophthalmologist",
      rating: 4.8,
      reviewCount: 113,
      imageUrl: "assets/images/doctor_image.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            context.l10n.featuredDoctors,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColor.tealNew,
                  letterSpacing: 0.5,
                ),
            semanticsLabel: context.l10n.featuredDoctors,
          ),
        ),
        SizedBox(height: 12.h),
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _doctors.length,
          options: CarouselOptions(
            height: 240.h,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            autoPlayCurve: Curves.easeInOutQuint,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return DoctorCard(
              doctor: _doctors[index],
              isActive: index == _currentPage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(doctor: _doctors[index]),
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_doctors.length, (index) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: index == _currentPage ? 32.w : 12.w,
                height: 12.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  gradient: index == _currentPage
                      ? LinearGradient(
                          colors: [AppColor.tealNew, AppColor.tealNew.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            AppColor.tealNew.withOpacity(0.2),
                            AppColor.tealNew.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(index == _currentPage ? 0.15 : 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorCardModel doctor;
  final bool isActive;
  final VoidCallback onTap;

  const DoctorCard({
    Key? key,
    required this.doctor,
    this.isActive = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isActive ? 1.0 : 0.95),
        margin: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: isActive ? 0 : 8.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              AppColor.tealNew.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isActive ? AppColor.tealNew.withOpacity(0.4) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.2 : 0.1),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Doctor image
                Hero(
                  tag: 'doctor_image_${doctor.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: doctor.imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: doctor.imageUrl,
                              fit: BoxFit.cover,
                              memCacheHeight: (100.h * MediaQuery.of(context).devicePixelRatio).round(),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => _buildFallbackImage(),
                            )
                          : Image.asset(
                              doctor.imageUrl,
                              width: 150.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              fontSize: 20.sp,
                              letterSpacing: 0.3,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        semanticsLabel: doctor.name,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        doctor.specialty,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                              fontSize: 16.sp,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        semanticsLabel: doctor.specialty,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade700,
                            size: 22.sp,
                            semanticLabel: 'Rating',
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  fontSize: 16.sp,
                                ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "(${doctor.reviewCount} reviews)",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black45,
                                  fontSize: 14.sp,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.tealNew,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 2,
                          shadowColor: AppColor.tealNew.withOpacity(0.3),
                          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                        ),
                        child: Text(
                          context.l10n.bookNow,
                          semanticsLabel: context.l10n.bookNow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.tealNew.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 48.sp,
          color: AppColor.tealNew.withOpacity(0.7),
          semanticLabel: 'Doctor placeholder',
        ),
      ),
    );
  }
}

class DoctorCardModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  DoctorCardModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}

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