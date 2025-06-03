import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_state.dart';
import 'package:alagy/features/home_screen/presentation/widgets/doctor_card_slider.dart';
import 'package:alagy/features/home_screen/presentation/widgets/home_app_bar.dart';
import 'package:alagy/features/home_screen/presentation/widgets/specializations_grid.dart';
import 'package:alagy/features/home_screen/presentation/widgets/top_rated_doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenPage();
}

class _HomeScreenPage extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
        listener: (context, state) {},
        child: Scaffold(
            body: CustomScrollView(
          slivers: [
            const HomeAppBar(),
            SliverPersistentHeader(
              pinned: false,
              delegate: SearchBarHeaderDelegate(height: 70.h),
            ),
            SliverToBoxAdapter(
              child:  BlocBuilder<HomeScreenCubit, HomeScreenState>(
          builder: (context, state) {
            if (state.isError) {
               return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          const Text(
            'Something went wrong',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Trigger a retry or refresh action
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
            }
            if(!state.isAllLoaded){
              return const Center(child: CircularProgressIndicator());
            }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      const DoctorCardSlider(),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          context.l10n.specializations,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SpecializationsGrid(),
                      SizedBox(height: 24.h),
                      const TopRatedDoctors(),
                      SizedBox(height: 70.h),
                    ],
                  );
                },
              ),
            ),
          ],
        )));
  }
}
