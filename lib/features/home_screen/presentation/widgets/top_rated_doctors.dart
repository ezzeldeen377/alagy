import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/home_screen/presentation/models/doctor_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Removed CachedNetworkImage import as it's now in top_doctor_card.dart

// Imports for separated classes
import './top_doctor_card.dart';

class TopRatedDoctors extends StatelessWidget {
  const TopRatedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
     List<DoctorCardModel> doctors = [
      DoctorCardModel(
        name: "Dr. Sarah Johnson",
        specialty: "Cardiologist",
        rating: 4.9,
        reviewCount: 124,
        imageUrl: "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8ZG9jdG9yfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60", // Replaced
      ),
      DoctorCardModel(
        name: "Dr. Michael Chen",
        specialty: "Neurologist",
        rating: 4.8,
        reviewCount: 98,
        imageUrl: "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZG9jdG9yfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60", // Replaced
      ),
      DoctorCardModel(
        name: "Dr. Aisha Rahman",
        specialty: "Pediatrician",
        rating: 4.7,
        reviewCount: 156,
        imageUrl: "https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", // Replaced
      ),
      DoctorCardModel(
        name: "Dr. James Wilson",
        specialty: "Dermatologist",
        rating: 4.6,
        reviewCount: 87,
        imageUrl: "https://images.unsplash.com/photo-1537368910025-700350fe46c7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8ZG9jdG9yfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60", // Replaced
      ),
      DoctorCardModel(
        name: "Dr. Maria Garcia",
        specialty: "Orthopedic Surgeon",
        rating: 4.9,
        reviewCount: 142,
        imageUrl: "https://images.unsplash.com/photo-1605107513004-368f8ebc7a74?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZlbWFsZSUyMGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", // Replaced
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // This padding is for the whole section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.topRatedDoctors,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all doctors page
                },
                child: Text(
                  context.l10n.seeAll,
                  style: const TextStyle(
                    color: AppColor.tealNew,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              // TopDoctorCard now handles its own internal padding and margins for the Card itself
              return TopDoctorCard(doctor: doctors[index]);
            },
          ),
        ],
      ),
    );
  }
}

// Removed TopDoctorCard class
// Removed TopDoctorModel class
