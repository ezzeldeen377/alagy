import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_state.dart';
import 'package:alagy/features/home_screen/presentation/widgets/top_doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  createState() => _DoctorPage();
}

class _DoctorPage extends State<DoctorPage> {
  @override
  void initState() {
    super.initState();
    // Fetch doctors when the page loads
    context.read<HomeScreenCubit>().getTopRatedDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctors',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          if (state.isLoadingTopRatedDoctor) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isErrorTopRatedDoctor) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading doctors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenCubit>().getTopRatedDoctors();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state.topRateddoctors == null || state.topRateddoctors!.isEmpty) {
            // If no data is available, use fake data
            return _buildDoctorList(DoctorFakeData.fakeDoctors);
          } else {
            return _buildDoctorList(state.topRateddoctors!);
          }
        },
      ),
    );
  }

  Widget _buildDoctorList(List<DoctorModel> doctors) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: TopDoctorCard(doctor: doctors[index]),
        );
      },
    );
  }
}
