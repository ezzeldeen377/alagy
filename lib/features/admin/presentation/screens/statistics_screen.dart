import 'dart:developer';

import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_state.dart';
import 'package:alagy/features/admin/presentation/widgets/admin_card.dart';
import 'package:alagy/features/admin/presentation/widgets/statistics_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.statistics,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        actions: [
          BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              return PopupMenuButton<DateFilter>(
                icon: Icon(
                  Icons.filter_list,
                  color: AppColor.whiteColor,
                ),
                onSelected: (DateFilter filter) {
                  context.read<AdminCubit>().changeFilter(filter);
                },
                itemBuilder: (BuildContext context) {
                  return DateFilter.values.map((DateFilter filter) {
                    return PopupMenuItem<DateFilter>(
                      value: filter,
                      child: Row(
                        children: [
                          Icon(
                            state.currentFilter == filter
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: state.currentFilter == filter
                                ? AppColor.primaryColor
                                : Colors.grey,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            filter.displayName,
                            style: TextStyle(
                              fontWeight: state.currentFilter == filter
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: state.currentFilter == filter
                                  ? AppColor.primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state.isError) {
            showSnackBar(context, state.errorMessage ?? context.l10n.anErrorOccurred,
                backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.loadingStatistics,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.statistics == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.noStatisticsAvailable,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdminCubit>().loadStatistics();
                    },
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          final statistics = state.statistics!;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminCubit>().loadStatistics(state.currentFilter);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Filter Display
                  _buildCurrentFilterDisplay(state),
                  SizedBox(height: 24.h),

                  // Overview Cards
                  Text(
                    context.l10n.overview,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.2,
                    children: [
                      AdminCard(
                        title: context.l10n.totalDoctors,
                        value: statistics.totalDoctors.toString(),
                        icon: Icons.medical_services,
                        color: Colors.blue,
                      ),
                      AdminCard(
                        title: context.l10n.totalPatients,
                        value: statistics.totalPatients.toString(),
                        icon: Icons.people,
                        color: Colors.green,
                      ),
                      AdminCard(
                        title: context.l10n.totalAppointments,
                        value: statistics.totalAppointments.toString(),
                        icon: Icons.calendar_today,
                        color: Colors.orange,
                      ),
                      AdminCard(
                        title: _getRevenueTitle(state.currentFilter),
                        value:
                            '\$${statistics.monthlyRevenue.toStringAsFixed(2)}',
                        icon: Icons.attach_money,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Doctor Status Breakdown
                  Text(
                    context.l10n.doctorStatusBreakdown,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AdminCard(
                          title: context.l10n.pendingDoctors,
                          value: statistics.pendingDoctors.toString(),
                          icon: Icons.hourglass_empty,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: AdminCard(
                          title: context.l10n.approvedDoctors,
                          value: statistics.approvedDoctors.toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AdminCard(
                          title: context.l10n.rejectedDoctors,
                          value: statistics.rejectedDoctors.toString(),
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Container(
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor.withOpacity(0.1),
                                AppColor.primaryColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pie_chart,
                                    color: AppColor.primaryColor,
                                    size: 32.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    context.l10n.viewChart,
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Statistics Chart
                  Text(
                    context.l10n.doctorStatusDistribution,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsChart(
                    pendingCount: statistics.pendingDoctors,
                    approvedCount: statistics.approvedDoctors,
                    rejectedCount: statistics.rejectedDoctors,
                  ),

                  SizedBox(height: 32.h),

                  // Additional Metrics
                  Text(
                    context.l10n.additionalMetrics,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          _buildMetricRow(
                            context.l10n.doctorApprovalRate,
                            '${_calculateApprovalRate(statistics).toStringAsFixed(1)}%',
                            Icons.trending_up,
                            Colors.green,
                          ),
                          Divider(height: 24.h),
                          _buildMetricRow(
                            context.l10n.averageRevenuePerDoctor,
                            '\$${_calculateAverageRevenue(statistics).toStringAsFixed(2)}',
                            Icons.monetization_on,
                            Colors.blue,
                          ),
                          Divider(height: 24.h),
                          _buildMetricRow(
                            context.l10n.appointmentsPerDoctor,
                            _calculateAppointmentsPerDoctor(statistics)
                                .toStringAsFixed(1),
                            Icons.event_note,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentFilterDisplay(AdminState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: AppColor.primaryColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              context.l10n.currentFilter,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColor.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                state.currentFilter.displayName,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterSection(AdminState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.filterByDate,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: DateFilter.values.map((filter) {
                final isSelected = state.currentFilter == filter;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: filter != DateFilter.values.last ? 8.w : 0),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AdminCubit>().changeFilter(filter);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.primaryColor
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColor.primaryColor
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          filter.displayName,
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getRevenueTitle(DateFilter filter) {
    switch (filter) {
      case DateFilter.today:
        return context.l10n.todaysRevenue;
      case DateFilter.thisMonth:
        return context.l10n.monthlyRevenue;
      case DateFilter.allTime:
        return context.l10n.totalRevenue;
    }
  }

  Widget _buildMetricRow(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
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
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            title,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  double _calculateApprovalRate(dynamic statistics) {
    final total = statistics.approvedDoctors + statistics.rejectedDoctors;
    if (total == 0) return 0.0;
    return (statistics.approvedDoctors / total) * 100;
  }

  double _calculateAverageRevenue(dynamic statistics) {
    if (statistics.totalDoctors == 0) return 0.0;
    return statistics.monthlyRevenue / statistics.totalDoctors;
  }

  double _calculateAppointmentsPerDoctor(dynamic statistics) {
    if (statistics.totalDoctors == 0) return 0.0;
    return statistics.totalAppointments / statistics.totalDoctors;
  }
}
