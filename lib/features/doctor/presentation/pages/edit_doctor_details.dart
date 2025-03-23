import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_app_bar.dart';
import 'package:alagy/core/utils/custom_container.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:alagy/features/doctor/presentation/widgets/bio_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddDoctorCubit>();
    return BlocListener<AddDoctorCubit, AddDoctorState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: context.l10n.editDoctorTitle, buttonText: context.l10n.skip),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0.w),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                // Profile Picture Upload
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70.r,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: cubit.state.doctor?.profileImage != null
                            ? NetworkImage(cubit.state.doctor!.profileImage!)
                            : null,
                        child: cubit.state.doctor?.profileImage == null
                            ? Icon(Icons.person, size: 70.r, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 18.r),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),
                SectionHeader(title: context.l10n.editDoctorProfilePicture),
                SizedBox(height: 10.h),

                // Personal Information Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: context.l10n.editDoctorPersonalInfo),
                      CustomTextField(
                        controller: cubit.nameController,
                        label: context.l10n.editDoctorName,
                        icon: Icons.person,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.emailController,
                        label: context.l10n.editDoctorEmail,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        isEnable: false,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.phoneNumberController,
                        label: context.l10n.editDoctorPhone,
                        icon: Icons.phone,
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.h),

                // Professional Information Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                          title: context.l10n.editDoctorProfessionalInfo),
                      CustomTextField(
                        controller: cubit.specializationController,
                        label: context.l10n.editDoctorSpecialization,
                        icon: Icons.work,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.qualificationController,
                        label: context.l10n.editDoctorQualification,
                        icon: Icons.school,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.licenseNumberController,
                        label: context.l10n.editDoctorLicense,
                        icon: Icons.assignment,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.hospitalOrClinicNameController,
                        label: context.l10n.editDoctorHospital,
                        icon: Icons.local_hospital,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.yearsOfExperienceController,
                        label: context.l10n.editDoctorExperience,
                        icon: Icons.timeline,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      CustomTextField(
                        controller: cubit.consultationFeeController,
                        label: context.l10n.editDoctorFee,
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        isRequired: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.h),

                // Bio Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: context.l10n.editDoctorBio),
                      BioTextField(
                        controller: cubit.bioController,
                        hintText: context.l10n.editDoctorBioHint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<AddDoctorCubit, AddDoctorState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.teal.shade700,
              elevation: 2,
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.save, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
