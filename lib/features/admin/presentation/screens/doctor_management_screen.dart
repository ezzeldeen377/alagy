import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_state.dart';
import 'package:alagy/features/admin/presentation/widgets/doctor_card.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({super.key});

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final adminCubit = context.read<AdminCubit>();
    adminCubit.loadPendingDoctors();
    adminCubit.loadApprovedDoctors();
    adminCubit.loadRejectedDoctors();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.doctorManagement,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.whiteColor,
          labelColor: AppColor.whiteColor,
          unselectedLabelColor: AppColor.whiteColor.withOpacity(0.7),
          tabs: [
            Tab(text: context.l10n.pending),
            Tab(text: context.l10n.approved),
            Tab(text: context.l10n.rejected),
          ],
        ),
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state.isError) {
            showSnackBar(context, state.errorMessage ?? context.l10n.anErrorOccurred,backgroundColor: Colors.red);
            
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Pending Doctors Tab
              _buildDoctorsList(
                doctors: state.pendingDoctors,
                isLoading: state.isLoading,
                emptyMessage: context.l10n.noPendingDoctors,
                showActions: true,
              ),
              // Approved Doctors Tab
              _buildDoctorsList(
                doctors: state.approvedDoctors,
                isLoading: state.isLoading,
                emptyMessage: context.l10n.noApprovedDoctors,
                showActions: false,
              ),
              // Rejected Doctors Tab
              _buildDoctorsList(
                doctors: state.rejectedDoctors,
                isLoading: state.isLoading,
                emptyMessage: context.l10n.noRejectedDoctors,
                showActions: false,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDoctorsList({
    required List<dynamic> doctors,
    required bool isLoading,
    required String emptyMessage,
    required bool showActions,
  }) {
    if (isLoading && doctors.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              emptyMessage,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final adminCubit = context.read<AdminCubit>();
        adminCubit.loadPendingDoctors();
        adminCubit.loadApprovedDoctors();
        adminCubit.loadRejectedDoctors();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index] as DoctorModel;
          return DoctorCard(
            doctor: doctor,
            showActions: showActions,
            onUpgradeToVip: () => context
                .read<AdminCubit>()
                .toggleVipStatus(doctor.uid, doctor.isVip??false),
            onApprove: showActions
                ? () => _showConfirmationDialog(
                      context,
                      context.l10n.approveDoctor,
                      context.l10n.areYouSureYouWantToApproveThisDoctor,
                      () async {
                        await context
                            .read<AdminCubit>()
                            .approveDoctor(doctor.uid);
                        await context.read<AdminCubit>().loadApprovedDoctors();
                        await context.read<AdminCubit>().loadPendingDoctors();
                      },
                    )
                : null,
            onReject: showActions
                ? () => _showConfirmationDialog(
                      context,
                      context.l10n.rejectDoctor,
                      context.l10n.areYouSureYouWantToRejectThisDoctor,
                      () async {
                        await context
                            .read<AdminCubit>()
                            .rejectDoctor(doctor.uid);
                        await context.read<AdminCubit>().loadRejectedDoctors();
                        await context.read<AdminCubit>().loadPendingDoctors();
                      },
                    )
                : null,
            // New callbacks for moving between approved and rejected
            onMoveToRejected: doctor.isAccepted == true
                ? () => _showConfirmationDialog(
                      context,
                      context.l10n.moveToRejected,
                      context.l10n.areYouSureYouWantToMoveThisDoctorToRejected,
                      () async {
                        await context
                            .read<AdminCubit>()
                            .rejectDoctor(doctor.uid);
                        await context.read<AdminCubit>().loadApprovedDoctors();
                        await context.read<AdminCubit>().loadRejectedDoctors();
                      },
                    )
                : null,
            onMoveToApproved: doctor.isAccepted == false
                ? () => _showConfirmationDialog(
                      context,
                      context.l10n.moveToApproved,
                      context.l10n.areYouSureYouWantToMoveThisDoctorToApproved,
                      () async {
                        await context
                            .read<AdminCubit>()
                            .approveDoctor(doctor.uid);
                        await context.read<AdminCubit>().loadApprovedDoctors();
                        await context.read<AdminCubit>().loadRejectedDoctors();
                      },
                    )
                : null,
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
              ),
              child: Text(
                context.l10n.confirm,
                style: const TextStyle(color: AppColor.whiteColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
