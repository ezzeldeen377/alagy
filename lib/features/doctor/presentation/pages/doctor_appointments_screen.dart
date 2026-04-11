import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DoctorAppointment> _currentAppointments = [];
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
        await context.read<DoctorDashboardCubit>().loadPendingAppointments(user.uid);
      } else if (status == 'completed') {
        await context.read<DoctorDashboardCubit>().loadCompletedAppointments(user.uid);
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
      body: BlocConsumer<DoctorDashboardCubit, DoctorDashboardState>(
        listener: (context, state) {
          if (state is DoctorDashboardPendingAppointmentsLoaded) {
            setState(() {
              _currentAppointments = state.appointments;
            });
          } else if (state is DoctorDashboardCompletedAppointmentsLoaded) {
            setState(() {
              _currentAppointments = state.appointments;
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildStatistics(),
              Expanded(
                child: state is DoctorDashboardLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is DoctorDashboardError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${context.l10n.error}${state.message}'),
                                ElevatedButton(
                                  onPressed: () => _loadAppointmentsByStatus(_selectedFilter),
                                  child: Text(context.l10n.retry),
                                ),
                              ],
                            ),
                          )
                        : _currentAppointments.isEmpty
                            ? _buildEmptyState()
                            : _buildAppointmentsList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatistics() {
    final now = DateTime.now();
    final upcomingCount = _selectedFilter == 'pending' ? _currentAppointments.length : 0;
    final completedCount = _selectedFilter == 'completed' ? _currentAppointments.length : 0;
    final totalRevenue = _selectedFilter == 'completed' 
        ? _currentAppointments.fold(0.0, (sum, apt) => sum + apt.price)
        : 0.0;

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
            child: _buildStatItem(context.l10n.upcoming, upcomingCount.toString(), Colors.blue),
          ),
          Expanded(
            child: _buildStatItem(context.l10n.completed, completedCount.toString(), Colors.green),
          ),
          Expanded(
            child: _buildStatItem(context.l10n.revenue, '\$${totalRevenue.toStringAsFixed(0)}', AppColor.primaryColor),
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

  Widget _buildAppointmentsList() {
    return RefreshIndicator(
      onRefresh: () async => await _loadAppointmentsByStatus(_selectedFilter),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _currentAppointments.length,
        itemBuilder: (context, index) {
          return _buildAppointmentCard(_currentAppointments[index]);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(DoctorAppointment appointment) {
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
          // Header with patient info and status
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    appointment.status.name.toUpperCase(),
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
          
          // Appointment details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.access_time,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      appointment.startTime.time,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      appointment.isOnline == true ? Icons.videocam : Icons.location_on,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      appointment.isOnline == true ? context.l10n.onlineConsultation : appointment.location ?? context.l10n.inPerson,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
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
                if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
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
                
                // Read-only info based on status
                _buildAppointmentInfo(appointment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo(DoctorAppointment appointment) {
    if (appointment.status == AppointmentStatus.confirmed) {
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
            Icon(
              Icons.schedule,
              color: Colors.blue,
              size: 16.sp,
            ),
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
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 16.sp,
            ),
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
          Icon(
            Icons.calendar_today_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            _selectedFilter == 'pending' ? context.l10n.noUpcomingAppointments : context.l10n.noCompletedAppointments,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _selectedFilter == 'pending' 
                ? context.l10n.upcomingAppointmentsWillAppearHere
                : context.l10n.appointmentHistoryWillAppearHere,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
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