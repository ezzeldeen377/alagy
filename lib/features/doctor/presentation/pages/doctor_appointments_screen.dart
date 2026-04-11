import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'pending';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointmentsByStatus('pending');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointmentsByStatus(String status) async {
    final user = context.read<AppUserCubit>().state.user;
    if (user != null) {
      if (status == 'pending') {
        await context
            .read<DoctorDashboardCubit>()
            .loadPendingAppointments(user.uid);
      } else if (status == 'completed') {
        await context
            .read<DoctorDashboardCubit>()
            .loadCompletedAppointments(user.uid);
      }
    }
  }

  void _onTabChanged(int index) {
    final filters = ['pending', 'completed'];
    final newFilter = filters[index];
    setState(() {
      _selectedFilter = newFilter;
    });
    _loadAppointmentsByStatus(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.theme.iconTheme.color),
        title: Text(context.l10n.myAppointments),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColor.primaryColor,
          onTap: _onTabChanged,
          tabs: [
            Tab(text: context.l10n.upcoming),
            Tab(text: context.l10n.completed),
          ],
        ),
      ),
      body: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
        builder: (context, state) {
          final appointments = state.appointments;
          return Column(
            children: [
              _buildStatistics(state),
              Expanded(
                child: state.status == DoctorDashboardStatus.loading &&
                        appointments.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : state.status == DoctorDashboardStatus.error &&
                            appointments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${context.l10n.error}${state.errorMessage}'),
                                ElevatedButton(
                                  onPressed: () => _loadAppointmentsByStatus(
                                      _selectedFilter),
                                  child: Text(context.l10n.retry),
                                ),
                              ],
                            ),
                          )
                        : appointments.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                onRefresh: () async =>
                                    await _loadAppointmentsByStatus(
                                        _selectedFilter),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(16.w),
                                  itemCount: appointments.length,
                                  itemBuilder: (context, index) {
                                    return _buildAppointmentCard(
                                        appointments[index], state);
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatistics(DoctorDashboardState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(context.l10n.upcoming,
                state.pendingCount.toString(), Colors.blue),
          ),
          Expanded(
            child: _buildStatItem(context.l10n.completed,
                state.completedCount.toString(), Colors.green),
          ),
          Expanded(
            child: _buildStatItem(
                context.l10n.revenue,
                '\$${state.totalRevenue.toStringAsFixed(0)}',
                AppColor.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(
      DoctorAppointment appointment, DoctorDashboardState state) {
    final isLoading = state.loadingAppointmentId == appointment.id;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getStatusColor(appointment.status).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
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
                          color:
                              Theme.of(context).textTheme.headlineLarge?.color,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        context.getSpecialty(appointment.specialization),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    appointment.status.name.tr(context).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16.sp, color: Colors.grey[600]),
                    SizedBox(width: 8.w),
                    Text(
                      '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.access_time,
                        size: 16.sp, color: Colors.grey[600]),
                    SizedBox(width: 8.w),
                    Text(
                      appointment.startTime.time,
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      appointment.isOnline == true
                          ? Icons.videocam
                          : Icons.location_on,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      appointment.isOnline == true
                          ? context.l10n.onlineConsultation
                          : appointment.location ?? context.l10n.inPerson,
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      '\$${appointment.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      appointment.notes!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                _buildAppointmentInfo(appointment, isLoading),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo(DoctorAppointment appointment, bool isLoading) {
    if (appointment.status == AppointmentStatus.confirmed ||
        appointment.status == AppointmentStatus.pending) {
      if (appointment.isPast) {
        return SizedBox(
          width: double.infinity,
          child: isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await context
                        .read<DoctorDashboardCubit>()
                        .completeAppointment(appointment.id!);
                    _loadAppointmentsByStatus(_selectedFilter);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    context.l10n.complete,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        );
      }
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: Colors.blue, size: 16.sp),
            SizedBox(width: 8.w),
            Text(
              context.l10n.scheduledAppointment,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (appointment.status == AppointmentStatus.completed) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
            SizedBox(width: 8.w),
            Text(
              context.l10n.appointmentCompleted,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            _selectedFilter == 'pending'
                ? context.l10n.noUpcomingAppointments
                : context.l10n.noCompletedAppointments,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            _selectedFilter == 'pending'
                ? context.l10n.upcomingAppointmentsWillAppearHere
                : context.l10n.appointmentHistoryWillAppearHere,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
