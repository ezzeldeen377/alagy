import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_calendar_cubit.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/settings/presentation/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_calendar_screen.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_appointments_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // For drawer navigation

  @override
  void initState() {
    super.initState();
    final user = context.read<AppUserCubit>().state.user;
    if (user != null) {
      context
          .read<AppUserCubit>()
          .updateNotificationToken(user, NotificationService.fcmToken);
      context.read<DoctorDashboardCubit>().loadDashboardData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state.isClearUserData) {
          context.pushNamedAndRemoveAll(RouteNames.signIn);
        }
        if (state.isSignOut) {
          context.read<AppUserCubit>().clearUserData();
        }
      },
      child: Scaffold(
        drawerScrimColor: Colors.black.withOpacity(0.3),
        drawerEdgeDragWidth: 20.w,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildCustomAppBar(),
        ),
        drawer: _buildDrawer(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  final user = context.read<AppUserCubit>().state.user;
                  if (user != null) {
                    await context
                        .read<DoctorDashboardCubit>()
                        .loadDashboardData(user.uid);
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsCards(state),
                      SizedBox(height: 24.h),
                      _buildTodayAppointments(state),
                      SizedBox(height: 24.h),
                      // _buildPendingRequests(state),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = context.read<AppUserCubit>().state.user;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.good} ${_getGreeting()}!',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${context.l10n.doctor} ${user?.name ?? context.l10n.doctor}',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColor.primaryColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(DoctorDashboardState state) {
    if (state is DoctorDashboardLoading) {
      return SizedBox(
        height: 120.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is DoctorDashboardError) {
      return Container(
        height: 120.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 32.sp),
              SizedBox(height: 8.h),
              Text(
                context.l10n.errorLoadingStatistics,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    final statistics =
        state is DoctorDashboardLoaded ? state.statistics : <String, int>{};

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context.l10n.totalPatients,
                statistics['totalPatients']?.toString() ?? '0',
                Icons.people_outline,
                AppColor.primaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                context.l10n.todaysAppointments,
                statistics['todayAppointments']?.toString() ?? '0',
                Icons.calendar_today_outlined,
                Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context.l10n.pendingRequests,
                statistics['pendingRequests']?.toString() ?? '0',
                Icons.pending_actions_outlined,
                Colors.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                context.l10n.completedToday,
                statistics['completedToday']?.toString() ?? '0',
                Icons.check_circle_outline,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineLarge?.color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAppointments(DoctorDashboardState state) {
    final appointments = state is DoctorDashboardLoaded
        ? state.todayAppointments
        : <DoctorAppointment>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.todaysAppointments,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        appointments.isEmpty
            ? _buildEmptyState(context.l10n.noAppointmentsToday)
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(appointments[index]);
                },
              ),
      ],
    );
  }

  Widget _buildPendingRequests(DoctorDashboardState state) {
    final pendingRequests = state is DoctorDashboardLoaded
        ? state.pendingRequests
        : <DoctorAppointment>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.pendingRequests,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to appointments screen with pending filter
              },
              child: Text(
                context.l10n.viewAll,
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        pendingRequests.isEmpty
            ? _buildEmptyState(context.l10n.noPendingRequests)
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(pendingRequests[index],
                      isPending: true);
                },
              ),
      ],
    );
  }

  Widget _buildAppointmentCard(DoctorAppointment appointment,
      {bool isPending = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                child: Text(
                  appointment.patientName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      appointment.specialization,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isPending) ...[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (appointment.id != null) {
                          context
                              .read<DoctorDashboardCubit>()
                              .acceptAppointment(appointment.id!);
                        }
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (appointment.id != null) {
                          context
                              .read<DoctorDashboardCubit>()
                              .rejectAppointment(appointment.id!);
                        }
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                appointment.startTime.time,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                appointment.isOnline == true
                    ? Icons.videocam
                    : Icons.location_on,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                appointment.isOnline == true ? context.l10n.online : context.l10n.inPerson,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.l10n.goodMorning;
    } else if (hour < 17) {
      return context.l10n.goodAfternoon;
    } else {
      return context.l10n.goodEvening;
    }
  }

  Widget _buildCustomAppBar() {
    final user = context.read<AppUserCubit>().state.user;

    return AppBar(
      elevation: 4,
      centerTitle: false,
      backgroundColor: AppColor.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' ${_getGreeting()}, Dr. ${user?.name ?? 'Doctor'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.whiteColor,
                ),
          ),
          Text(
            context.l10n.welcomeToYourDashboard,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColor.whiteColor,
                ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            context.pushNamed(RouteNames.notifications);
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    final user = context.read<AppUserCubit>().state.user;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          // Enhanced Drawer Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor,
                  AppColor.primaryColor.withOpacity(0.8),
                  const Color(0xFF1565C0)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Avatar with enhanced styling
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35.r,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user?.profileImage ??
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 35.r,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // User Name with enhanced styling
                    Text(
                      'Dr. ${user?.name ?? 'Doctor'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // User Email with enhanced styling
                    Text(
                      user?.email ?? 'doctor@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_outlined,
                  title: context.l10n.dashboard,
                  index: 0,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: context.l10n.calendar,
                  index: 1,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => getIt<DoctorCalendarCubit>(),
                                child: const DoctorCalendarScreen(),
                              )),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.people_outline,
                  title: context.l10n.appointments,
                  index: 2,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) =>
                                    getIt<DoctorDashboardCubit>(),
                                child: const DoctorAppointmentsScreen(),
                              )),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: context.l10n.profile,
                  index: 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: context.l10n.logout,
                  index: -1,
                  onTap: () {
                    Navigator.pop(context);
                    showLogoutDialog(context);
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final isSelected = _currentIndex == index && !isLogout;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: isSelected
            ? AppColor.primaryColor.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.red
              : isSelected
                  ? AppColor.primaryColor
                  : Colors.grey[600],
          size: 24.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? Colors.red
                : isSelected
                    ? AppColor.primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16.sp,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
