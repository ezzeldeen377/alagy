// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get editDoctorTitle => 'Edit Profile';

  @override
  String get editDoctorPersonalInfo => 'Personal Information';

  @override
  String get editDoctorProfessionalInfo => 'Professional Information';

  @override
  String get editDoctorBio => 'Bio';

  @override
  String get editDoctorBioHint => 'Write something about yourself...';

  @override
  String get editDoctorRequiredField => 'This field is required';

  @override
  String get editDoctorInvalidEmail => 'Please enter a valid email address';

  @override
  String get editDoctorInvalidPhone =>
      'Phone number must be at least 10 digits';

  @override
  String get editDoctorBioRequired => 'Please write something about yourself';

  @override
  String get editDoctorName => 'Name';

  @override
  String get editDoctorEmail => 'Email';

  @override
  String get editDoctorPhone => 'Phone Number';

  @override
  String get editDoctorProfilePicture => 'Profile Picture';

  @override
  String get editDoctorSpecialization => 'Specialization';

  @override
  String get editDoctorQualification => 'Qualification';

  @override
  String get editDoctorLicense => 'License Number';

  @override
  String get editDoctorHospital => 'Hospital/Clinic Name';

  @override
  String get editDoctorExperience => 'Years of Experience';

  @override
  String get editDoctorFee => 'Consultation Fee';

  @override
  String get editDoctorAddress => 'Address';

  @override
  String get skip => 'Skip';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get onboardingWelcome => 'Welcome';

  @override
  String get onboardingTitle => 'Welcome to Alagy. Your Health, Our Priority';

  @override
  String get onboardingDescription =>
      'Easily book appointments, consult doctors, and manage your medical records anytime, anywhere.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signInWelcomeBack => 'Welcome back! please sign in to continue.';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signInDividerOr => 'Or';

  @override
  String get signInEmailLabel => 'Email';

  @override
  String get signInEmailHint => 'Enter your email address';

  @override
  String get signInPasswordLabel => 'Password';

  @override
  String get signInPasswordHint => 'Enter your password';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get registerNow => 'Register Now';

  @override
  String get connectWithGoogle => 'Connect with Google';

  @override
  String get signUpTitle => 'Getting Started';

  @override
  String get signUpSubtitle => 'Create an account to continue!';

  @override
  String get patientTab => 'Patient';

  @override
  String get doctorTab => 'Doctor';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get termsAndConditionsError => 'Please accept terms and conditions';

  @override
  String get signUpEmailLabel => 'Email';

  @override
  String get signUpEmailHint => 'Enter your email address';

  @override
  String get signUpUsernameLabel => 'Username';

  @override
  String get signUpUsernameHint => 'Enter your name';

  @override
  String get validatorEmptyField =>
      'Oops! It looks like you missed this one. Please fill it in.';

  @override
  String get validatorInvalidPhone =>
      'Please enter a valid Egyptian mobile number (starting with 01 followed by 9 numbers).';

  @override
  String get validatorInvalidNumber =>
      'Please enter a valid number greater than 0.';

  @override
  String get validatorEnterEmail => 'Please enter your email';

  @override
  String get validatorInvalidEmail => 'Please enter a valid email address';

  @override
  String get validatorEnterPassword => 'Please enter your password';

  @override
  String get validatorInvalidPassword =>
      'Password must be at least 8 characters,\ninclude an uppercase letter,\n number, and symbol';

  @override
  String get signUpPasswordLabel => 'Password';

  @override
  String get signUpPasswordHint => 'Enter password';

  @override
  String get signUpConfirmPasswordLabel => 'Confirm Password';

  @override
  String get signUpConfirmPasswordHint => 'Confirm Password';

  @override
  String get signUpConfirmPasswordError => 'please enter your Confirm Password';

  @override
  String get signUpPasswordMismatchError =>
      'Password and Confirm Password must be same';

  @override
  String get signUpTermsText => 'By creating an account, you agree to our';

  @override
  String get signUpTermsLink => 'Terms & Conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get tryCatchNetworkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get tryCatchInvalidEmail => 'Please enter a valid email address';

  @override
  String get tryCatchUserDisabled => 'This account has been disabled';

  @override
  String get tryCatchUserNotFound =>
      'Account not found. Please check your credentials';

  @override
  String get tryCatchWrongPassword => 'Incorrect password';

  @override
  String get tryCatchEmailInUse => 'This email is already registered';

  @override
  String get tryCatchWeakPassword => 'Please use a stronger password';

  @override
  String get tryCatchInvalidCredential => 'Invalid email or password';

  @override
  String get tryCatchTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get tryCatchOperationNotAllowed =>
      'This operation is not allowed. Please try again later.';

  @override
  String get tryCatchAuthFailed => 'Authentication failed. Please try again.';

  @override
  String get appName => 'Alagy';

  @override
  String get settings => 'Settings';

  @override
  String welcomeMessage(Object name) {
    return 'Welcome, $name';
  }

  @override
  String roleLabel(Object role) {
    return 'Role: $role';
  }

  @override
  String get signOut => 'Sign Out';

  @override
  String get tryCatchRequestTimeout =>
      'Request timed out. Please check your connection and try again.';

  @override
  String get tryCatchServiceUnavailable =>
      'Service temporarily unavailable. Please try again later.';

  @override
  String get tryCatchGenericError =>
      'Something went wrong. Please try again later.';

  @override
  String get editDoctorSave => 'Save';

  @override
  String get editDoctorCompleteDataLater =>
      'You can complete entering data later and continue to the application.';

  @override
  String get retryButton => 'Retry';

  @override
  String get dialogAlertTitle => 'Alert';

  @override
  String get dialogOkButton => 'OK';

  @override
  String get generalError => 'An error occurred. Please try again.';

  @override
  String get createAccountSuccessfully => 'Account created successfully.';

  @override
  String get deleteDataSuccessfully => 'Data deleted successfully.';

  @override
  String get forgetPassword => 'Forget Password?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordInstructions =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent. Please check your inbox.';

  @override
  String get home => 'Home';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get search => 'Search';

  @override
  String get notifications => 'Notifications';

  @override
  String get topDoctors => 'Top Doctors';

  @override
  String get ourServices => 'Our Services';

  @override
  String get chatWithDoctor => 'Chat with Doctor';

  @override
  String get chatWithDoctorDescription =>
      'Instant messaging with healthcare professionals';

  @override
  String get videoConsultation => 'Video Consultation';

  @override
  String get videoConsultationDescription =>
      'Face-to-face virtual appointments with specialists';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get voiceCallDescription =>
      'Quick phone consultations for medical advice';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get bookAppointmentDescription =>
      'Schedule in-person visits with your doctor';

  @override
  String get topRatedDoctors => 'Top Rated Doctors';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get seeAll => 'See All';

  @override
  String get featuredDoctors => 'Featured Doctors';

  @override
  String get reviews => 'Reviews';

  @override
  String get logout => 'Logout';

  @override
  String get editDoctorLocation => 'Location';

  @override
  String get editDoctorLatitude => 'Latitude';

  @override
  String get editDoctorLongitude => 'Longitude';

  @override
  String get editDoctorLocationNotSet => 'Not set';

  @override
  String get editDoctorSelectLocation => 'Select Location from Map';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied';

  @override
  String locationError(Object error) {
    return 'Failed to get location: $error';
  }

  @override
  String get selectLocationTitle => 'Select Location';

  @override
  String get selectedLocationTitle => 'Selected Location';

  @override
  String get saveLocation => 'Save Location';

  @override
  String get specialty_internal_medicine => 'Internal Medicine';

  @override
  String get specialty_general_surgery => 'General Surgery';

  @override
  String get specialty_pediatrics => 'Pediatrics';

  @override
  String get specialty_gynecology => 'Gynecology and Obstetrics';

  @override
  String get specialty_orthopedics => 'Orthopedic Surgery';

  @override
  String get specialty_urology => 'Urology';

  @override
  String get specialty_ent => 'Otorhinolaryngology (Ear, Nose, and Throat)';

  @override
  String get specialty_dermatology => 'Dermatology';

  @override
  String get specialty_ophthalmology => 'Ophthalmology';

  @override
  String get specialty_dentistry => 'Dental Medicine';

  @override
  String get specialty_emergency => 'Emergency Medicine';

  @override
  String get specialty_laboratory => 'Medical Laboratory';

  @override
  String get specialty_radiology => 'Radiology and Medical Imaging';

  @override
  String get specialty_cardiology => 'Cardiology';

  @override
  String get specialty_cardiothoracic_surgery => 'Cardiothoracic Surgery';

  @override
  String get specialty_neurosurgery => 'Neurosurgery';

  @override
  String get specialty_oncology => 'Oncology';

  @override
  String get specialty_nephrology => 'Nephrology';

  @override
  String get specialty_pulmonology => 'Pulmonology and Respiratory Medicine';

  @override
  String get specialty_rheumatology => 'Rheumatology';

  @override
  String get specialty_rehabilitation => 'Physical Medicine and Rehabilitation';

  @override
  String get specialty_psychiatry => 'Psychiatry';

  @override
  String get specialty_hematology => 'Hematology';

  @override
  String get specialty_infectious_diseases => 'Infectious Disease Medicine';

  @override
  String get specialty_endocrinology => 'Endocrinology';

  @override
  String get specialty_icu => 'Intensive Care Unit';

  @override
  String get specialty_burns_plastic => 'Burn and Plastic Surgery';

  @override
  String get specialty_laparoscopy => 'Laparoscopic Surgery';

  @override
  String get specialty_vascular_surgery => 'Vascular Surgery';

  @override
  String get specialty_geriatrics => 'Geriatric Medicine';

  @override
  String get specialty_audiology => 'Audiology';

  @override
  String get specialty_neonatology => 'Neonatology';

  @override
  String get editDoctorChangeLocation => 'Change Location';

  @override
  String get editDoctorLocationSelected => 'Location Selected';

  @override
  String get editDoctorAvailability => 'Edit Doctor Availability';

  @override
  String get editDoctorCustomDays => 'Enable Custom Days';

  @override
  String get editDoctorStartTime => 'Start Time';

  @override
  String get editDoctorEndTime => 'End Time';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get editDoctorSelectDay => 'Select a Day';

  @override
  String get editDoctorDayAvailable => 'Day Available';

  @override
  String get editDoctorDayClosed => 'This day is marked as closed';

  @override
  String get doctorDetailContactInfo => 'Contact Information';

  @override
  String get doctorDetailProfessionalInfo => 'Professional Information';

  @override
  String get doctorDetailHospital => 'Hospital/Clinic';

  @override
  String get doctorDetailLocation => 'Location';

  @override
  String get doctorDetailBio => 'About Doctor';

  @override
  String get doctorDetailAvailability => 'Availability';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get city => 'City';

  @override
  String get qualification => 'Qualification';

  @override
  String get licenseNumber => 'License Number';

  @override
  String get yearsOfExperience => 'Years of Experience';

  @override
  String get consultationFee => 'Consultation Fee';

  @override
  String get hospitalOrClinic => 'Hospital or Clinic';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get closed => 'Closed';

  @override
  String get bookNow => 'Book Now';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get doctorProfileShared => 'Doctor profile shared';

  @override
  String get call => 'Call';

  @override
  String get book => 'Book Appointment';

  @override
  String get bookingFeatureComingSoon => 'Booking feature coming soon';

  @override
  String get address => 'Address';

  @override
  String get mapViewComingSoon => 'Map view coming soon';

  @override
  String get directions => 'Directions';

  @override
  String get yearsExp => 'years experience';

  @override
  String get availabilitySchedule => 'Availability Schedule';

  @override
  String get availableTimeSlots => 'Available Time Slots';

  @override
  String reviewsCount(Object count) {
    return '$count reviews';
  }

  @override
  String ratingPercentage(Object percentage) {
    return '$percentage%';
  }

  @override
  String get writeAReview => 'Write a Review';

  @override
  String get shareYourExperience => 'Share your experience';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get featureNotImplemented => 'Review submission not implemented';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get closedOnThisDay => 'Closed on this day';

  @override
  String get pm => 'PM';

  @override
  String get am => 'AM';

  @override
  String get appointment => 'Appointment';

  @override
  String get searchPlaceholder => 'Search doctors, medicines etc...';

  @override
  String get howAreYou => 'how are you today?';

  @override
  String greeting(Object name) {
    return 'Hi, $name!';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get specialty_empty => 'No specialty';
}
