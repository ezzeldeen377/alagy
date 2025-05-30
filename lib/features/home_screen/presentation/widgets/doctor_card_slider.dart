import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Imports for separated classes
import '../models/doctor_card_model.dart';
import './doctor_card.dart';
import '../../../doctor/presentation/pages/doctor_detail_page.dart';

class DoctorCardSlider extends StatefulWidget {
  const DoctorCardSlider({super.key});

  @override
  State<DoctorCardSlider> createState() => _DoctorCardSliderState();
}

class _DoctorCardSliderState extends State<DoctorCardSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final vipDoctors=context.read<HomeScreenCubit>().state.vipdoctors??[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            context.l10n.featuredDoctors,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            semanticsLabel: context.l10n.featuredDoctors,
          ),
        ),
        SizedBox(height: 12.h),
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: vipDoctors.length,
          options: CarouselOptions(
            height: 200.h,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            enableInfiniteScroll: true,
            autoPlay: false,
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
              doctor: vipDoctors[index],
              isActive: index == _currentPage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(
                        doctor: vipDoctors[index]
                        ),
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(vipDoctors.length, (index) {
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
                          colors: [
                            AppColor.tealNew,
                            AppColor.tealNew.withOpacity(0.7)
                          ],
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
                      color: Colors.black
                          .withOpacity(index == _currentPage ? 0.15 : 0.05),
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

// Removed DoctorCard class
// Removed DoctorCardModel class
// Removed DoctorDetailPage class
