import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/home_screen/presentation/models/doctor_card_model.dart';
import 'package:alagy/features/home_screen/presentation/widgets/favourite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

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
  context.pushNamed(RouteNames.doctorDetails,
                  arguments:doctor);
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
                                  doctor.profileImage??'',
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
                                      context.getSpecialty(doctor.specialization??''),
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
                                          doctor.rating?.toStringAsFixed(1)??'0',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp, // Increased font size
                                              ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '(${doctor.reviews.length})',
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
                            top: 0.r,
                            right:context.isRtl?null: 0.r,
                            left:context.isRtl?0.r: null,
                            child:FavoriteIcon(doctor:doctor ,)
                          ),
                        ],
                      ),
                    ),
                  ),
                );
  }

  
}
