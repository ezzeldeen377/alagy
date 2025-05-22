import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit() : super(const AddDoctorState());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController hospitalOrClinicNameController = TextEditingController();
  final TextEditingController yearsOfExperienceController = TextEditingController();
  final TextEditingController consultationFeeController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Future<void> close() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    specializationController.dispose();
    qualificationController.dispose();
    licenseNumberController.dispose();
    hospitalOrClinicNameController.dispose();
    yearsOfExperienceController.dispose();
    consultationFeeController.dispose();
    bioController.dispose();
    return super.close();
  }
  void addDoctor() async {
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: error.toString(),
      ));
    }
  }

  void resetState() {
    emit(const AddDoctorState());
  }
}
