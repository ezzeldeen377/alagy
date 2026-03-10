import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});
 
  @override
  Widget build(BuildContext context) {
    final List<ServiceModel> services = [
      ServiceModel(
        title: context.l10n.chatWithDoctor,
        icon: Icons.chat_rounded,
        color: Colors.blue,
        description: context.l10n.chatWithDoctorDescription,
      ),
      ServiceModel(
        title: context.l10n.videoConsultation,
        icon: Icons.videocam_rounded,
        color: Colors.purple,
        description: context.l10n.videoConsultationDescription,
      ),
      ServiceModel(
        title: context.l10n.voiceCall,
        icon: Icons.call_rounded,
        color: Colors.green,
        description: context.l10n.voiceCallDescription,
      ),
      ServiceModel(
        title: context.l10n.bookAppointment,
        icon: Icons.calendar_month_rounded,
        color: Colors.orange,
        description: context.l10n.bookAppointmentDescription,
      ),
    ];
    
    return SizedBox(
      height: 150.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 12.w),
            child: ServiceCard(service: services[index]),
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle service tap
      },
      child: Card(
        elevation: 5,
        shadowColor:            context.isDark ? Colors.blueGrey.withOpacity(0.1) : Colors.black.withOpacity(0.1),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              margin: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service.icon,
                color: service.color,
                size: 30.sp,
              ),
            ),
            Text(
              service.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              service.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 10.sp,
                    
                  ),
                  textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h,)
          ],
        ),
      ),
    );
  }
}

class ServiceModel {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const ServiceModel({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}
