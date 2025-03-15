import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/utils/image_picker.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit({required this.repository})
      : super(const AddDoctorState(status: AddDoctorStatus.initial));
  DoctorRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController hospitalOrClinicNameController =
      TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController consultationFeeController =
      TextEditingController();
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
    addressController.dispose();
    bioController.dispose();
    return super.close();
  }

  void initState(UserModel doctor) {
    emit(state.copyWith(status: AddDoctorStatus.initial, doctor: doctor));
  }

  Future<void> addDoctor() async {
    emit(state.copyWith(status: AddDoctorStatus.loading));
    final response = await repository.addDoctor(prepareDoctorData());
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.error, errorMessage: error.message));
    }, (success) {
      emit(state.copyWith(status: AddDoctorStatus.success));
    });
      
  }

  Future<void> pickPofilePicture() async {
    emit(state.copyWith(status: AddDoctorStatus.pickProfileImageLoading));
    final image = await pickImage();
    if (image != null) {
      emit(state.copyWith(
        status: AddDoctorStatus.pickProfileImageSuccess,
        selectedProfilePicture: image,
      ));
    
    }else{
          emit(state.copyWith(status: AddDoctorStatus.pickProfileImageError));

    }
  }

  Future<void> uploadProfilePicture() async {
    emit(state.copyWith(status: AddDoctorStatus.uploadProfilePictureLoading));
    final response =
        await repository.uploadProfilePicture(state.selectedProfilePicture!);
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.uploadProfilePictureError,
          errorMessage: error.message));
    }, (url) {
      emit(state.copyWith(
          status: AddDoctorStatus.uploadProfilePictureSuccess,
          profilePictureUrl: url));
    });
  }

  void resetState() {
    emit(const AddDoctorState(status: AddDoctorStatus.initial));
  }
  
  DoctorModel prepareDoctorData() {
    return DoctorModel(
     uid: state.doctor?.uid ?? '',
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      address: addressController.text,
      specialization: specializationController.text,
      qualification: qualificationController.text,
      licenseNumber: licenseNumberController.text,
      hospitalName: hospitalOrClinicNameController.text,
      createdAt: DateTime.now(),
      consultationFee:consultationFeeController.text.isEmpty?null: double.parse(consultationFeeController.text),
      profileImage: state.profilePictureUrl??state.doctor?.profileImage?? '',
      yearsOfExperience:yearsOfExperienceController.text.isEmpty?null: int.parse(yearsOfExperienceController.text),
      bio: bioController.text,
    );
  }
  void initControllers() {
      nameController.text = state.doctor?.name??'';
      emailController.text = state.doctor?.email??'';
      phoneNumberController.text = state.doctor?.phoneNumber??'';
    
    
  }
}
