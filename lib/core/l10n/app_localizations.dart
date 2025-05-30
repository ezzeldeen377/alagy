import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @editDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editDoctorTitle;

  /// No description provided for @editDoctorPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get editDoctorPersonalInfo;

  /// No description provided for @editDoctorProfessionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get editDoctorProfessionalInfo;

  /// No description provided for @editDoctorBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editDoctorBio;

  /// No description provided for @editDoctorBioHint.
  ///
  /// In en, this message translates to:
  /// **'Write something about yourself...'**
  String get editDoctorBioHint;

  /// No description provided for @editDoctorRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get editDoctorRequiredField;

  /// No description provided for @editDoctorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get editDoctorInvalidEmail;

  /// No description provided for @editDoctorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 10 digits'**
  String get editDoctorInvalidPhone;

  /// No description provided for @editDoctorBioRequired.
  ///
  /// In en, this message translates to:
  /// **'Please write something about yourself'**
  String get editDoctorBioRequired;

  /// No description provided for @editDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editDoctorName;

  /// No description provided for @editDoctorEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editDoctorEmail;

  /// No description provided for @editDoctorPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editDoctorPhone;

  /// No description provided for @editDoctorProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get editDoctorProfilePicture;

  /// No description provided for @editDoctorSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get editDoctorSpecialization;

  /// No description provided for @editDoctorQualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get editDoctorQualification;

  /// No description provided for @editDoctorLicense.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get editDoctorLicense;

  /// No description provided for @editDoctorHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital/Clinic Name'**
  String get editDoctorHospital;

  /// No description provided for @editDoctorExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get editDoctorExperience;

  /// No description provided for @editDoctorFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get editDoctorFee;

  /// No description provided for @editDoctorAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get editDoctorAddress;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcome;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Alagy. Your Health, Our Priority'**
  String get onboardingTitle;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Easily book appointments, consult doctors, and manage your medical records anytime, anywhere.'**
  String get onboardingDescription;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @signInWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! please sign in to continue.'**
  String get signInWelcomeBack;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signInDividerOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get signInDividerOr;

  /// No description provided for @signInEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInEmailLabel;

  /// No description provided for @signInEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signInEmailHint;

  /// No description provided for @signInPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPasswordLabel;

  /// No description provided for @signInPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get signInPasswordHint;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @connectWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get connectWithGoogle;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to continue!'**
  String get signUpSubtitle;

  /// No description provided for @patientTab.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientTab;

  /// No description provided for @doctorTab.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorTab;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @termsAndConditionsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions'**
  String get termsAndConditionsError;

  /// No description provided for @signUpEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpEmailLabel;

  /// No description provided for @signUpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signUpEmailHint;

  /// No description provided for @signUpUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get signUpUsernameLabel;

  /// No description provided for @signUpUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get signUpUsernameHint;

  /// No description provided for @validatorEmptyField.
  ///
  /// In en, this message translates to:
  /// **'Oops! It looks like you missed this one. Please fill it in.'**
  String get validatorEmptyField;

  /// No description provided for @validatorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Egyptian mobile number (starting with 01 followed by 9 numbers).'**
  String get validatorInvalidPhone;

  /// No description provided for @validatorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number greater than 0.'**
  String get validatorInvalidNumber;

  /// No description provided for @validatorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validatorEnterEmail;

  /// No description provided for @validatorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validatorInvalidEmail;

  /// No description provided for @validatorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validatorEnterPassword;

  /// No description provided for @validatorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters,\ninclude an uppercase letter,\n number, and symbol'**
  String get validatorInvalidPassword;

  /// No description provided for @signUpPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPasswordLabel;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get signUpPasswordHint;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @signUpConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordHint;

  /// No description provided for @signUpConfirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'please enter your Confirm Password'**
  String get signUpConfirmPasswordError;

  /// No description provided for @signUpPasswordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Password and Confirm Password must be same'**
  String get signUpPasswordMismatchError;

  /// No description provided for @signUpTermsText.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our'**
  String get signUpTermsText;

  /// No description provided for @signUpTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get signUpTermsLink;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @tryCatchNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get tryCatchNetworkError;

  /// No description provided for @tryCatchInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get tryCatchInvalidEmail;

  /// No description provided for @tryCatchUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get tryCatchUserDisabled;

  /// No description provided for @tryCatchUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found. Please check your credentials'**
  String get tryCatchUserNotFound;

  /// No description provided for @tryCatchWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get tryCatchWrongPassword;

  /// No description provided for @tryCatchEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get tryCatchEmailInUse;

  /// No description provided for @tryCatchWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please use a stronger password'**
  String get tryCatchWeakPassword;

  /// No description provided for @tryCatchInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get tryCatchInvalidCredential;

  /// No description provided for @tryCatchTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tryCatchTooManyRequests;

  /// No description provided for @tryCatchOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed. Please try again later.'**
  String get tryCatchOperationNotAllowed;

  /// No description provided for @tryCatchAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get tryCatchAuthFailed;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Alagy'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeMessage(Object name);

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String roleLabel(Object role);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @tryCatchRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please check your connection and try again.'**
  String get tryCatchRequestTimeout;

  /// No description provided for @tryCatchServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Please try again later.'**
  String get tryCatchServiceUnavailable;

  /// No description provided for @tryCatchGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get tryCatchGenericError;

  /// No description provided for @editDoctorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editDoctorSave;

  /// No description provided for @editDoctorCompleteDataLater.
  ///
  /// In en, this message translates to:
  /// **'You can complete entering data later and continue to the application.'**
  String get editDoctorCompleteDataLater;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @dialogAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get dialogAlertTitle;

  /// No description provided for @dialogOkButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOkButton;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get generalError;

  /// No description provided for @createAccountSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get createAccountSuccessfully;

  /// No description provided for @deleteDataSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully.'**
  String get deleteDataSuccessfully;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordInstructions;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Please check your inbox.'**
  String get passwordResetEmailSent;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @topDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Doctors'**
  String get topDoctors;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @chatWithDoctor.
  ///
  /// In en, this message translates to:
  /// **'Chat with Doctor'**
  String get chatWithDoctor;

  /// No description provided for @chatWithDoctorDescription.
  ///
  /// In en, this message translates to:
  /// **'Instant messaging with healthcare professionals'**
  String get chatWithDoctorDescription;

  /// No description provided for @videoConsultation.
  ///
  /// In en, this message translates to:
  /// **'Video Consultation'**
  String get videoConsultation;

  /// No description provided for @videoConsultationDescription.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face virtual appointments with specialists'**
  String get videoConsultationDescription;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get voiceCall;

  /// No description provided for @voiceCallDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick phone consultations for medical advice'**
  String get voiceCallDescription;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @bookAppointmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule in-person visits with your doctor'**
  String get bookAppointmentDescription;

  /// No description provided for @topRatedDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Doctors'**
  String get topRatedDoctors;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @featuredDoctors.
  ///
  /// In en, this message translates to:
  /// **'Featured Doctors'**
  String get featuredDoctors;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editDoctorLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editDoctorLocation;

  /// No description provided for @editDoctorLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get editDoctorLatitude;

  /// No description provided for @editDoctorLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get editDoctorLongitude;

  /// No description provided for @editDoctorLocationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get editDoctorLocationNotSet;

  /// No description provided for @editDoctorSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location from Map'**
  String get editDoctorSelectLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location: {error}'**
  String locationError(Object error);

  /// No description provided for @selectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocationTitle;

  /// No description provided for @selectedLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocationTitle;

  /// No description provided for @saveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save Location'**
  String get saveLocation;

  /// No description provided for @specialty_internal_medicine.
  ///
  /// In en, this message translates to:
  /// **'Internal Medicine'**
  String get specialty_internal_medicine;

  /// No description provided for @specialty_general_surgery.
  ///
  /// In en, this message translates to:
  /// **'General Surgery'**
  String get specialty_general_surgery;

  /// No description provided for @specialty_pediatrics.
  ///
  /// In en, this message translates to:
  /// **'Pediatrics'**
  String get specialty_pediatrics;

  /// No description provided for @specialty_gynecology.
  ///
  /// In en, this message translates to:
  /// **'Gynecology and Obstetrics'**
  String get specialty_gynecology;

  /// No description provided for @specialty_orthopedics.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Surgery'**
  String get specialty_orthopedics;

  /// No description provided for @specialty_urology.
  ///
  /// In en, this message translates to:
  /// **'Urology'**
  String get specialty_urology;

  /// No description provided for @specialty_ent.
  ///
  /// In en, this message translates to:
  /// **'Otorhinolaryngology (Ear, Nose, and Throat)'**
  String get specialty_ent;

  /// No description provided for @specialty_dermatology.
  ///
  /// In en, this message translates to:
  /// **'Dermatology'**
  String get specialty_dermatology;

  /// No description provided for @specialty_ophthalmology.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmology'**
  String get specialty_ophthalmology;

  /// No description provided for @specialty_dentistry.
  ///
  /// In en, this message translates to:
  /// **'Dental Medicine'**
  String get specialty_dentistry;

  /// No description provided for @specialty_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Medicine'**
  String get specialty_emergency;

  /// No description provided for @specialty_laboratory.
  ///
  /// In en, this message translates to:
  /// **'Medical Laboratory'**
  String get specialty_laboratory;

  /// No description provided for @specialty_radiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology and Medical Imaging'**
  String get specialty_radiology;

  /// No description provided for @specialty_cardiology.
  ///
  /// In en, this message translates to:
  /// **'Cardiology'**
  String get specialty_cardiology;

  /// No description provided for @specialty_cardiothoracic_surgery.
  ///
  /// In en, this message translates to:
  /// **'Cardiothoracic Surgery'**
  String get specialty_cardiothoracic_surgery;

  /// No description provided for @specialty_neurosurgery.
  ///
  /// In en, this message translates to:
  /// **'Neurosurgery'**
  String get specialty_neurosurgery;

  /// No description provided for @specialty_oncology.
  ///
  /// In en, this message translates to:
  /// **'Oncology'**
  String get specialty_oncology;

  /// No description provided for @specialty_nephrology.
  ///
  /// In en, this message translates to:
  /// **'Nephrology'**
  String get specialty_nephrology;

  /// No description provided for @specialty_pulmonology.
  ///
  /// In en, this message translates to:
  /// **'Pulmonology and Respiratory Medicine'**
  String get specialty_pulmonology;

  /// No description provided for @specialty_rheumatology.
  ///
  /// In en, this message translates to:
  /// **'Rheumatology'**
  String get specialty_rheumatology;

  /// No description provided for @specialty_rehabilitation.
  ///
  /// In en, this message translates to:
  /// **'Physical Medicine and Rehabilitation'**
  String get specialty_rehabilitation;

  /// No description provided for @specialty_psychiatry.
  ///
  /// In en, this message translates to:
  /// **'Psychiatry'**
  String get specialty_psychiatry;

  /// No description provided for @specialty_hematology.
  ///
  /// In en, this message translates to:
  /// **'Hematology'**
  String get specialty_hematology;

  /// No description provided for @specialty_infectious_diseases.
  ///
  /// In en, this message translates to:
  /// **'Infectious Disease Medicine'**
  String get specialty_infectious_diseases;

  /// No description provided for @specialty_endocrinology.
  ///
  /// In en, this message translates to:
  /// **'Endocrinology'**
  String get specialty_endocrinology;

  /// No description provided for @specialty_icu.
  ///
  /// In en, this message translates to:
  /// **'Intensive Care Unit'**
  String get specialty_icu;

  /// No description provided for @specialty_burns_plastic.
  ///
  /// In en, this message translates to:
  /// **'Burn and Plastic Surgery'**
  String get specialty_burns_plastic;

  /// No description provided for @specialty_laparoscopy.
  ///
  /// In en, this message translates to:
  /// **'Laparoscopic Surgery'**
  String get specialty_laparoscopy;

  /// No description provided for @specialty_vascular_surgery.
  ///
  /// In en, this message translates to:
  /// **'Vascular Surgery'**
  String get specialty_vascular_surgery;

  /// No description provided for @specialty_geriatrics.
  ///
  /// In en, this message translates to:
  /// **'Geriatric Medicine'**
  String get specialty_geriatrics;

  /// No description provided for @specialty_audiology.
  ///
  /// In en, this message translates to:
  /// **'Audiology'**
  String get specialty_audiology;

  /// No description provided for @specialty_neonatology.
  ///
  /// In en, this message translates to:
  /// **'Neonatology'**
  String get specialty_neonatology;

  /// No description provided for @editDoctorChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get editDoctorChangeLocation;

  /// No description provided for @editDoctorLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected'**
  String get editDoctorLocationSelected;

  /// No description provided for @editDoctorAvailability.
  ///
  /// In en, this message translates to:
  /// **'Edit Doctor Availability'**
  String get editDoctorAvailability;

  /// No description provided for @editDoctorCustomDays.
  ///
  /// In en, this message translates to:
  /// **'Enable Custom Days'**
  String get editDoctorCustomDays;

  /// No description provided for @editDoctorStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get editDoctorStartTime;

  /// No description provided for @editDoctorEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get editDoctorEndTime;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @editDoctorSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Select a Day'**
  String get editDoctorSelectDay;

  /// No description provided for @editDoctorDayAvailable.
  ///
  /// In en, this message translates to:
  /// **'Day Available'**
  String get editDoctorDayAvailable;

  /// No description provided for @editDoctorDayClosed.
  ///
  /// In en, this message translates to:
  /// **'This day is marked as closed'**
  String get editDoctorDayClosed;

  /// No description provided for @doctorDetailContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get doctorDetailContactInfo;

  /// No description provided for @doctorDetailProfessionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get doctorDetailProfessionalInfo;

  /// No description provided for @doctorDetailHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital/Clinic'**
  String get doctorDetailHospital;

  /// No description provided for @doctorDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get doctorDetailLocation;

  /// No description provided for @doctorDetailBio.
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get doctorDetailBio;

  /// No description provided for @doctorDetailAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get doctorDetailAvailability;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @qualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualification;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsOfExperience;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get consultationFee;

  /// No description provided for @hospitalOrClinic.
  ///
  /// In en, this message translates to:
  /// **'Hospital or Clinic'**
  String get hospitalOrClinic;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @doctorProfileShared.
  ///
  /// In en, this message translates to:
  /// **'Doctor profile shared'**
  String get doctorProfileShared;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get book;

  /// No description provided for @bookingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking feature coming soon'**
  String get bookingFeatureComingSoon;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @mapViewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Map view coming soon'**
  String get mapViewComingSoon;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @yearsExp.
  ///
  /// In en, this message translates to:
  /// **'years experience'**
  String get yearsExp;

  /// No description provided for @availabilitySchedule.
  ///
  /// In en, this message translates to:
  /// **'Availability Schedule'**
  String get availabilitySchedule;

  /// No description provided for @availableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableTimeSlots;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(Object count);

  /// No description provided for @ratingPercentage.
  ///
  /// In en, this message translates to:
  /// **'{percentage}%'**
  String ratingPercentage(Object percentage);

  /// No description provided for @writeAReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeAReview;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareYourExperience;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @featureNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Review submission not implemented'**
  String get featureNotImplemented;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @closedOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'Closed on this day'**
  String get closedOnThisDay;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search doctors, medicines etc...'**
  String get searchPlaceholder;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'how are you today?'**
  String get howAreYou;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String greeting(Object name);

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @specialty_empty.
  ///
  /// In en, this message translates to:
  /// **'No specialty'**
  String get specialty_empty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
