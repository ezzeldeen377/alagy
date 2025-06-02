import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_app_bar.dart';
import 'package:alagy/core/utils/custom_button.dart';
import 'package:alagy/core/utils/custom_container.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_state.dart';
import 'package:alagy/features/doctor/presentation/widgets/bio_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_add_doctor_bloc_listener.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_dropdown_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_profile_picture.dart';
import 'package:alagy/features/doctor/presentation/widgets/custom_text_field.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddDoctorCubit>();
    return CustomAddDoctorBlocListener(
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.editDoctorTitle,
          buttonText: context.l10n.skip,
        ),
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
                        keyboardType: TextInputType.name,
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
                      BlocBuilder<AddDoctorCubit, AddDoctorState>(
                        builder: (context, state) {
                          return CustomDropdownField<String>(
                            value:
                                cubit.specializationController.text.isNotEmpty
                                    ? cubit.specializationController.text
                                    : null,
                            items: AppConstants.specialtiesKeys.map((key) {
                              print(
                                  "key ${cubit.specializationController.text}");
                              return DropdownMenuItem<String>(
                                value: key,
                                child: SizedBox(
                                  width: 200
                                      .w, // Set a max width suitable for your layout
                                  child: Text(
                                    context.getSpecialty(key),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              );
                            }).toList(),
                            label: context.l10n.editDoctorSpecialization,
                            icon: Icons.work,
                            onChanged: (value) {
                              cubit.specializationController.text = value ?? '';
                            },
                            validator: emptyValidator,
                          );
                        },
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

                // Location Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: context.l10n.editDoctorLocation),
                      BlocBuilder<AddDoctorCubit, AddDoctorState>(
                        buildWhen: (previous, current) =>
                            previous.latitude != current.latitude ||
                            previous.longitude != current.longitude,
                        builder: (context, state) {
                          final isLocationSelected =
                              state.latitude != null && state.longitude != null;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on,
                                  color: isLocationSelected
                                      ? AppColor.tealNew
                                      : Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isLocationSelected
                                      ? context.l10n
                                          .editDoctorLocationSelected // e.g. "Select location done"
                                      : context.l10n
                                          .editDoctorLocationNotSet, // e.g. "No location selected"
                                  style: context.theme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: isLocationSelected
                                        ? AppColor.white
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                icon:
                                    const Icon(Icons.route, color: AppColor.tealNew),
                                label: Text(
                                  context.l10n.editDoctorSelectLocation,
                                  style: context.theme.textTheme.titleSmall
                                      ?.copyWith(
                                          color: AppColor.tealNew,
                                          fontSize: 10.sp),
                                ),
                                onPressed: () async {
                                  // Navigate to the map screen and await the selected location
                                  LatLng? selectedLocation =
                                      await Navigator.pushNamed(
                                    context,
                                    RouteNames
                                        .selectLocationScreen, // Make sure this route is defined
                                  ) as LatLng?;
                                  if (selectedLocation != null) {
                                    cubit.updateLocation(
                                      latitude: selectedLocation.latitude,
                                      longitude: selectedLocation.longitude,
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      verticalSpace(10),
                    ],
                  ),
                ),
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: context.l10n.editDoctorAvailability),
                      BlocBuilder<AddDoctorCubit, AddDoctorState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.editDoctorCustomDays,
                                    style: context.theme.textTheme.bodyMedium,
                                  ),
                                  Switch(
                                    value: state.isCustomAvailability ?? false,
                                    onChanged: (value) {
                                      cubit.toggleCustomAvailability(value);
                                    },
                                    activeColor: AppColor.tealNew,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                              if (!(state.isCustomAvailability!)) ...[
                                // Uniform weekly availability
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller:
                                            cubit.weeklyStartTimeController,
                                        label: context.l10n.editDoctorStartTime,
                                        icon: Icons.access_time,
                                        readOnly: true,
                                        onTap: () async {
                                          final formattedTime =
                                              await pickTime(context);
                                          if (formattedTime != null) {
                                            cubit.updateWeeklyStartTime(
                                                formattedTime);
                                            print("start time $formattedTime");
                                          }
                                        },
                                        validator: emptyValidator,
                                      ),
                                    ),
                                    SizedBox(width: 8.w), // Reduced width
                                    Expanded(
                                      child: CustomTextField(
                                        controller:
                                            cubit.weeklyEndTimeController,
                                        label: context.l10n.editDoctorEndTime,
                                        icon: Icons.access_time,
                                        readOnly: true,
                                        onTap: () async {
                                          final formattedTime =
                                              await pickTime(context);
                                          if (formattedTime != null) {
                                            cubit.updateWeeklyEndTime(
                                                formattedTime);
                                            print("end time $formattedTime");
                                          }
                                        },
                                        validator: emptyValidator,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                // Custom day selection with dropdown
                                CustomDropdownField<String>(
                                  value: state.selectedDay,
                                  items: AppConstants.daysOfWeek.map((day) {
                                    return DropdownMenuItem<String>(
                                      value: day,
                                      child: Text(context.getDayOfWeek(day)),
                                    );
                                  }).toList(),
                                  label: context.l10n.editDoctorSelectDay,
                                  icon: Icons.calendar_today,
                                  onChanged: (value) {
                                    if (value != null) {
                                      cubit.selectDay(value);
                                    }
                                  },
                                ),

                                if (state.selectedDay != null) ...[
                                  verticalSpace(5), // Reduced space
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context.l10n.editDoctorDayAvailable,
                                        style:
                                            context.theme.textTheme.bodyMedium,
                                      ),
                                      Switch(
                                        value: !(state.dayIsClosed?[
                                                state.selectedDay] ??
                                            false),
                                        onChanged: (value) {
                                          cubit.toggleDayAvailability(
                                              state.selectedDay!, !value);
                                        },
                                        activeColor: AppColor.tealNew,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  ),

                                  if (!(state.dayIsClosed?[state.selectedDay] ??
                                      false)) ...[
                                    verticalSpace(5), // Reduced space
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            controller:
                                                cubit.dayStartTimeControllers[
                                                    state.selectedDay]!,
                                            label: context
                                                .l10n.editDoctorStartTime,
                                            icon: Icons.access_time,
                                            readOnly: true,
                                            onTap: () async {
                                              final time =
                                                  await pickTime(context);
                                              if (time != null) {
                                                cubit.updateDayStartTime(
                                                    state.selectedDay!, time);
                                              }
                                            },
                                            validator: emptyValidator,
                                          ),
                                        ),
                                        SizedBox(width: 8.w), // Reduced width
                                        Expanded(
                                          child: CustomTextField(
                                            controller:
                                                cubit.dayEndTimeControllers[
                                                    state.selectedDay]!,
                                            label:
                                                context.l10n.editDoctorEndTime,
                                            icon: Icons.access_time,
                                            readOnly: true,
                                            onTap: () async {
                                              final time =
                                                  await pickTime(context);
                                              if (time != null) {
                                                cubit.updateDayEndTime(
                                                    state.selectedDay!, time);
                                              }
                                            },
                                            validator: emptyValidator,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    verticalSpace(5), // Reduced space
                                    Container(
                                      padding: EdgeInsets.all(
                                          5.w), // Reduced padding
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            6), // Smaller radius
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Make row only as wide as needed
                                        children: [
                                          const Icon(Icons.do_not_disturb,
                                              color: Colors.red,
                                              size: 16), // Smaller icon
                                          SizedBox(width: 4.w), // Reduced width
                                          Text(
                                            context.l10n.editDoctorDayClosed,
                                            style: context
                                                .theme.textTheme.bodySmall
                                                ?.copyWith(
                                              // Smaller text
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ],
                          );
                        },
                      ),
                      verticalSpace(5), // Reduced space
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
                          if (state.selectedProfilePicture != null) {
                            cubit.uploadProfilePicture();
                          } else {
                            cubit.addDoctor();
                          }
                        }
                      },
                    );
                  },
                ),
                verticalSpace(10),
                TextButton(
                    onPressed: () {
                      context.pushNamedAndRemoveAll(RouteNames.initial);
                    },
                    child: Text(
                      context.l10n.editDoctorCompleteDataLater,
                      style: context.theme.textTheme.bodySmall,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> pickTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      return MaterialLocalizations.of(context)
          .formatTimeOfDay(time, alwaysUse24HourFormat: false);
    } else {
      return null;
    }
  }
}
