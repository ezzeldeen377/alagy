import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_app_bar.dart';
import 'package:alagy/core/utils/custom_button.dart';
import 'package:alagy/core/utils/custom_container.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:alagy/features/doctor/presentation/widgets/bio_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_add_doctor_bloc_listener.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_profile_picture.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: CustomAddDoctorBlocListener (
        child: Scaffold(
          appBar: CustomAppBar(
              title: context.l10n.editDoctorTitle, buttonText: context.l10n.skip,),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0.w),
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  // Profile Picture Upload
                  const CustomProfilePicture(),
        
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
                          validator: emptyValidator,
                        ),
                        CustomTextField(
                          controller: cubit.emailController,
                          label: context.l10n.editDoctorEmail,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          isEnable: true,
                          validator: emailValidator,
                        ),
                        CustomTextField(
                          controller: cubit.phoneNumberController,
                          label: context.l10n.editDoctorPhone,
                          icon: Icons.phone,
                          validator: phoneValidator,
                          keyboardType: TextInputType.phone,
                        ),
                        CustomTextField(
                          controller: cubit.addressController,
                          label: context.l10n.editDoctorAddress,
                          icon: Icons.home,
                          validator: emptyValidator,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20.h),
        
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
                          validator: emptyValidator,
                        ),
                        CustomTextField(
                          controller: cubit.qualificationController,
                          label: context.l10n.editDoctorQualification,
                          icon: Icons.school,
                        ),
                        CustomTextField(
                          controller: cubit.licenseNumberController,
                          label: context.l10n.editDoctorLicense,
                          icon: Icons.assignment,
                        ),
                        CustomTextField(
                          controller: cubit.hospitalOrClinicNameController,
                          label: context.l10n.editDoctorHospital,
                          icon: Icons.local_hospital,
                        ),
                        CustomTextField(
                          controller: cubit.yearsOfExperienceController,
                          label: context.l10n.editDoctorExperience,
                          icon: Icons.timeline,
                          keyboardType: TextInputType.number,
                        ),
                        CustomTextField(
                          controller: cubit.consultationFeeController,
                          label: context.l10n.editDoctorFee,
                          icon: Icons.attach_money,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: numbersValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20.h),
        
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
                        verticalSpace(10)
                      ],
                    ),
                  ),
                  verticalSpace(20),
                  BlocBuilder<AddDoctorCubit, AddDoctorState>(
                    builder: (context, state) {
                      return CustomButton(
                        buttonContent:
                            state.isLoading || state.isUploadProfilePictureLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    context.l10n.editDoctorSave,
                                    style: context.theme.textTheme.titleLarge
                                        ?.copyWith(color: AppColor.white),
                                  ),
                        onTapButton: () {
                          if (cubit.formKey.currentState!.validate()) {
                            if(state.selectedProfilePicture!=null){
                              cubit.uploadProfilePicture();
                            }else {
                              cubit.addDoctor();
                            }
                          }
                        },
                      );
                    },
                  ),
                  verticalSpace(10),
                  TextButton(
                      onPressed: () {context.pushNamedAndRemoveAll(RouteNames.initial)              ;},
                      child: Text(
                        context.l10n.editDoctorCompleteDataLater,
                        style: context.theme.textTheme.bodySmall,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
