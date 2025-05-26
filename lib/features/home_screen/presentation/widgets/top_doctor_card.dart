import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/home_screen/presentation/models/doctor_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopDoctorCard extends StatelessWidget {
  final DoctorCardModel doctor;

  const TopDoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 250.w, // Increased width from 200.w to 250.w
                  margin: EdgeInsets.only(right: 16.w),
                  child: InkWell(
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
                            profileImage:doctor.imageUrl
                                ,)),
                  ),
                );
        },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.r),
                                  topRight: Radius.circular(12.r),
                                ),
                                child: Image.network(
                                  doctor.imageUrl,
                                  height: 120.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.r), // Increased padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.name,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp, // Increased font size
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      doctor.specialty,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 12.sp, // Increased font size
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 18.r), // Increased icon size
                                        SizedBox(width: 4.w),
                                        Text(
                                          doctor.rating.toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp, // Increased font size
                                              ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '(${doctor.reviewCount})',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 12.sp, // Increased font size
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8.r,
                            right:context.isRtl?null: 8.r,
                            left:context.isRtl?8.r: null,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color:context.isDark? AppColor.darkGray:AppColor.lightGray,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                
                                Icons.favorite_border,
                                color: AppColor.tealNew,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
  }

  
}
