import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/home_screen/presentation/widgets/doctor_card_slider.dart';
import 'package:alagy/features/home_screen/presentation/widgets/home_app_bar.dart';
import 'package:alagy/features/home_screen/presentation/widgets/services_grid.dart';
import 'package:alagy/features/home_screen/presentation/widgets/specializations_grid.dart';
import 'package:alagy/features/home_screen/presentation/widgets/top_rated_doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenPage();
}

class _HomeScreenPage extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
         const HomeAppBar(),
         SliverPersistentHeader(
      pinned: true,
      delegate: SearchBarHeaderDelegate(height: 70.h),
    ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                const DoctorCardSlider(),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    context.l10n.ourServices,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SpecializationsGrid(),
                SizedBox(height: 24.h),
                const TopRatedDoctors(),
                SizedBox(height: 70.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

