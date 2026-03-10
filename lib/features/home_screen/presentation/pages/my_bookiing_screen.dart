import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/widgets/sign_in_required_widget.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/home_screen/presentation/bloc/my_booking/my_booking_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/my_booking/my_booking_state';
import 'package:alagy/features/home_screen/presentation/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookiingScreen extends StatefulWidget {
  const MyBookiingScreen({super.key});

  @override
  State<MyBookiingScreen> createState() => _MyBookiingScreenState();
}

class _MyBookiingScreenState extends State<MyBookiingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppUserCubit>().state.user;
    final isUserSignedIn = !context.read<AppUserCubit>().state.isNotLogin;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!isUserSignedIn) {
      return Scaffold(body: SignInRequiredWidget());
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black26 : Colors.grey[200],
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              fontFamily: 'Inter',
            ),
            tabs: [
              Tab(text: context.l10n.upcoming),
              Tab(text: context.l10n.completed),
              Tab(text: context.l10n.cancelled),
            ],
          ),
        ),
      ),
      body: BlocBuilder<MyBookingCubit, MyBookingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            );
          } else if (state.isError) {
            return _buildErrorView(context, user?.uid ?? '');
          }

          final allAppointments = state.bookings;

          final upcomingAppointments = allAppointments
              .where((a) =>
                  a.status == AppointmentStatus.pending ||
                  a.status == AppointmentStatus.confirmed)
              .toList();

          final completedAppointments = allAppointments
              .where((a) => a.status == AppointmentStatus.completed)
              .toList();

          final cancelledAppointments = allAppointments
              .where((a) => a.status == AppointmentStatus.cancelled)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(
                  context, upcomingAppointments, _EmptyStateType.upcoming),
              _buildAppointmentList(
                  context, completedAppointments, _EmptyStateType.completed),
              _buildAppointmentList(
                  context, cancelledAppointments, _EmptyStateType.cancelled),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppointmentList(BuildContext context,
      List<DoctorAppointment> appointments, _EmptyStateType type) {
    if (appointments.isEmpty) {
      return _buildEmptyState(context, type);
    }

    return RefreshIndicator(
      onRefresh: () async {
        final user = context.read<AppUserCubit>().state.user;
        if (user != null) {
          await context.read<MyBookingCubit>().getMyBookings(user.uid);
        }
      },
      color: AppColor.primaryColor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: appointments.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return AppointmentCard(appointment: appointments[index]);
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String uid) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColor.redColor,
            size: 64.r,
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.errorLoadingAppointments,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              context.read<MyBookingCubit>().getMyBookings(uid);
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, _EmptyStateType type) {
    IconData icon;
    String title;
    String subtitle;

    switch (type) {
      case _EmptyStateType.upcoming:
        icon = Icons.calendar_today_rounded;
        title = context.l10n.noUpcomingAppointments;
        subtitle = context.l10n.bookAnAppointmentWithADoctorToSeeItHere;
        break;
      case _EmptyStateType.completed:
        icon = Icons.task_alt_rounded;
        title = context.l10n.noCompletedAppointments;
        subtitle = context.l10n.appointmentHistoryWillAppearHere;
        break;
      case _EmptyStateType.cancelled:
        icon = Icons.event_busy_rounded;
        title = context.l10n.noAppointmentsYet; // Or specific cancelled text
        subtitle = "";
        break;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: context.isDark ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48.r,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _EmptyStateType {
  upcoming,
  completed,
  cancelled,
}
