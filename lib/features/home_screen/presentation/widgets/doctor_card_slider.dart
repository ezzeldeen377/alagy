import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Imports for separated classes
import '../models/doctor_card_model.dart';
import './doctor_card.dart';
import '../../../doctor/presentation/pages/doctor_detail_page.dart';

class DoctorCardSlider extends StatefulWidget {
  const DoctorCardSlider({Key? key}) : super(key: key);

  @override
  State<DoctorCardSlider> createState() => _DoctorCardSliderState();
}

class _DoctorCardSliderState extends State<DoctorCardSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;

  final List<DoctorCardModel> _doctors = [
    DoctorCardModel(
      name: "Dr. Sarah Johnson",
      specialty: "Cardiologist",
      rating: 4.8,
      reviewCount: 124,
      imageUrl: "assets/images/doctor_image.png",
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
            height: 200.h,
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
                    builder: (context) => DoctorDetailPage(
                        doctor: DoctorModel(
                            uid: '12345',
                            name: "Dr. Sarah Johnson",
                            email: "gfdgdfgdf",
                            phoneNumber: "0123456789",address: "gfdgdfgdf",
                            specialization: "Cardiologist",
                            yearsOfExperience: 10,
                            city: "gfdgdfgdf",
                            consultationFee: 100,
                            qualification: "gfdgdfgdf",
                            hospitalName: "gfdgdfgdf",

                            bio: " gfdgdfgdf fsdfsfd asdfasdasf dafsd fsdffsdfs s fdsdfdsf s dffsdfsq er fweewtw sdfsdfs xcsdfsdfsdfs asdlmkl;fnw wdfkdf ",
                            createdAt: DateTime.now(),
                            profileImage:
                              "https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"
                                ,)),
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
