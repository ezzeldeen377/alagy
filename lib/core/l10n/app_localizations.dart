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

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'activated'**
  String get activated;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeCodes.
  ///
  /// In en, this message translates to:
  /// **'Active Codes'**
  String get activeCodes;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @additionalMetrics.
  ///
  /// In en, this message translates to:
  /// **'Additional Metrics'**
  String get additionalMetrics;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @adminTab.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminTab;

  /// No description provided for @advancedOptions.
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptions;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rosheta'**
  String get appName;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @appointmentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Appointment added successfully'**
  String get appointmentAddedSuccessfully;

  /// No description provided for @appointmentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Appointment Completed'**
  String get appointmentCompleted;

  /// No description provided for @appointmentHistoryWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your appointment history will appear here'**
  String get appointmentHistoryWillAppearHere;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @appointmentsFor.
  ///
  /// In en, this message translates to:
  /// **'المواعيد لتاريخ'**
  String get appointmentsFor;

  /// No description provided for @appointmentsHistory.
  ///
  /// In en, this message translates to:
  /// **'Appointments History'**
  String get appointmentsHistory;

  /// No description provided for @appointmentsPerDoctor.
  ///
  /// In en, this message translates to:
  /// **'Appointments per Doctor'**
  String get appointmentsPerDoctor;

  /// No description provided for @approvalStatus.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get approvalStatus;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @approvedDoctors.
  ///
  /// In en, this message translates to:
  /// **'Approved Doctors'**
  String get approvedDoctors;

  /// No description provided for @approveDoctor.
  ///
  /// In en, this message translates to:
  /// **'Approve Doctor'**
  String get approveDoctor;

  /// No description provided for @approveOrRejectDoctorApplications.
  ///
  /// In en, this message translates to:
  /// **'Approve or reject doctor applications'**
  String get approveOrRejectDoctorApplications;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @areYouSureDeleteCode.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String areYouSureDeleteCode(Object name);

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @areYouSureYouWantToApproveThisDoctor.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this doctor?'**
  String get areYouSureYouWantToApproveThisDoctor;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @areYouSureYouWantToMoveThisDoctorToApproved.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to move this doctor to approved?'**
  String get areYouSureYouWantToMoveThisDoctorToApproved;

  /// No description provided for @areYouSureYouWantToMoveThisDoctorToRejected.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to move this doctor to rejected?'**
  String get areYouSureYouWantToMoveThisDoctorToRejected;

  /// No description provided for @areYouSureYouWantToRejectThisDoctor.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this doctor?'**
  String get areYouSureYouWantToRejectThisDoctor;

  /// No description provided for @availabilitySchedule.
  ///
  /// In en, this message translates to:
  /// **'Availability Schedule'**
  String get availabilitySchedule;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @availableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableTimeSlots;

  /// No description provided for @averageRevenuePerDoctor.
  ///
  /// In en, this message translates to:
  /// **'Average Revenue per Doctor'**
  String get averageRevenuePerDoctor;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'😞  bad'**
  String get bad;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio: '**
  String get bio;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get book;

  /// No description provided for @bookAnAppointmentWithADoctorToSeeItHere.
  ///
  /// In en, this message translates to:
  /// **'Book an appointment with a doctor to see it here'**
  String get bookAnAppointmentWithADoctorToSeeItHere;

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

  /// No description provided for @bookingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking feature coming soon'**
  String get bookingFeatureComingSoon;

  /// No description provided for @bookmarkHistory.
  ///
  /// In en, this message translates to:
  /// **'Bookmark History'**
  String get bookmarkHistory;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordArabic.
  ///
  /// In en, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePasswordArabic;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

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

  /// No description provided for @chestDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chest Diseases'**
  String get chestDiseases;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'اختر'**
  String get choose;

  /// No description provided for @chooseAppointmentTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the type of appointment you want to book'**
  String get chooseAppointmentTypeDescription;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityOptional.
  ///
  /// In en, this message translates to:
  /// **'City (Optional)'**
  String get cityOptional;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @closedOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'Closed on this day'**
  String get closedOnThisDay;

  /// No description provided for @codeCodeIsactiveDeactivatedActivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Code is deactivated/activated successfully'**
  String get codeCodeIsactiveDeactivatedActivatedSuccessfully;

  /// No description provided for @codeCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code \"{code}\" copied to clipboard'**
  String codeCopiedToClipboard(Object code);

  /// No description provided for @codeDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Code deleted successfully'**
  String get codeDeletedSuccessfully;

  /// No description provided for @codeMinimumLength.
  ///
  /// In en, this message translates to:
  /// **'Code must be at least 3 characters'**
  String get codeMinimumLength;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed Today'**
  String get completedToday;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointment;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @connectWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get connectWithGoogle;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// No description provided for @consultationDescription.
  ///
  /// In en, this message translates to:
  /// **'First-time visit or new medical concern'**
  String get consultationDescription;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get consultationFee;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactUsArabic.
  ///
  /// In en, this message translates to:
  /// **'تواصل معانا'**
  String get contactUsArabic;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @cosmeticSurgery.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic Surgery'**
  String get cosmeticSurgery;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @createAccountSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get createAccountSuccessfully;

  /// No description provided for @createAndManageDiscountCodes.
  ///
  /// In en, this message translates to:
  /// **'Create and manage discount codes'**
  String get createAndManageDiscountCodes;

  /// No description provided for @createCode.
  ///
  /// In en, this message translates to:
  /// **'Create Code'**
  String get createCode;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @createDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Create Discount Code'**
  String get createDiscountCode;

  /// No description provided for @createYourFirstDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Create your first discount code to get started'**
  String get createYourFirstDiscountCode;

  /// No description provided for @currentFilter.
  ///
  /// In en, this message translates to:
  /// **'Current Filter:'**
  String get currentFilter;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'deactivated'**
  String get deactivated;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountArabic.
  ///
  /// In en, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccountArabic;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @areYouSureDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get areYouSureDeleteAccount;

  /// No description provided for @deleteDataSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully.'**
  String get deleteDataSuccessfully;

  /// No description provided for @deleteDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Delete Discount Code'**
  String get deleteDiscountCode;

  /// No description provided for @dentistry.
  ///
  /// In en, this message translates to:
  /// **'Dentistry'**
  String get dentistry;

  /// No description provided for @dermatology.
  ///
  /// In en, this message translates to:
  /// **'Dermatology'**
  String get dermatology;

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

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount (EGP)'**
  String get discountAmount;

  /// No description provided for @discountAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 50'**
  String get discountAmountHint;

  /// No description provided for @discountCode.
  ///
  /// In en, this message translates to:
  /// **'Discount Code'**
  String get discountCode;

  /// No description provided for @discountCodeAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Discount code already exists'**
  String get discountCodeAlreadyExists;

  /// No description provided for @discountCodeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Discount code created successfully'**
  String get discountCodeCreatedSuccessfully;

  /// No description provided for @discountCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., SUMMER20'**
  String get discountCodeHint;

  /// No description provided for @discountCodeManagement.
  ///
  /// In en, this message translates to:
  /// **'Discount Code Management'**
  String get discountCodeManagement;

  /// No description provided for @discountCodes.
  ///
  /// In en, this message translates to:
  /// **'Discount Codes'**
  String get discountCodes;

  /// No description provided for @discountName.
  ///
  /// In en, this message translates to:
  /// **'Discount Name'**
  String get discountName;

  /// No description provided for @discountNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Summer Sale 2024'**
  String get discountNameHint;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// No description provided for @discountPercentageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 20'**
  String get discountPercentageHint;

  /// No description provided for @discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @doctorApprovalRate.
  ///
  /// In en, this message translates to:
  /// **'Doctor Approval Rate'**
  String get doctorApprovalRate;

  /// No description provided for @doctorApproved.
  ///
  /// In en, this message translates to:
  /// **'Doctor approved successfully'**
  String get doctorApproved;

  /// No description provided for @doctorDetailAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get doctorDetailAvailability;

  /// No description provided for @doctorDetailBio.
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get doctorDetailBio;

  /// No description provided for @doctorDetailContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get doctorDetailContactInfo;

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

  /// No description provided for @doctorDetailProfessionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get doctorDetailProfessionalInfo;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @doctorManagement.
  ///
  /// In en, this message translates to:
  /// **'Doctor Management'**
  String get doctorManagement;

  /// No description provided for @doctorProfileShared.
  ///
  /// In en, this message translates to:
  /// **'Doctor profile shared'**
  String get doctorProfileShared;

  /// No description provided for @doctorRejected.
  ///
  /// In en, this message translates to:
  /// **'Doctor rejected successfully'**
  String get doctorRejected;

  /// No description provided for @doctorStatusBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Doctor Status Breakdown'**
  String get doctorStatusBreakdown;

  /// No description provided for @doctorStatusDistribution.
  ///
  /// In en, this message translates to:
  /// **'Doctor Status Distribution'**
  String get doctorStatusDistribution;

  /// No description provided for @doctorTab.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorTab;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @editDoctorAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get editDoctorAddress;

  /// No description provided for @editDoctorAvailability.
  ///
  /// In en, this message translates to:
  /// **'Edit Doctor Availability'**
  String get editDoctorAvailability;

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

  /// No description provided for @editDoctorBioRequired.
  ///
  /// In en, this message translates to:
  /// **'Please write something about yourself'**
  String get editDoctorBioRequired;

  /// No description provided for @editDoctorChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get editDoctorChangeLocation;

  /// No description provided for @editDoctorCompleteDataLater.
  ///
  /// In en, this message translates to:
  /// **'You can complete entering data later and continue to the application.'**
  String get editDoctorCompleteDataLater;

  /// No description provided for @editDoctorCustomDays.
  ///
  /// In en, this message translates to:
  /// **'Enable Custom Days'**
  String get editDoctorCustomDays;

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

  /// No description provided for @editDoctorEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editDoctorEmail;

  /// No description provided for @editDoctorEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get editDoctorEndTime;

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

  /// No description provided for @editDoctorHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital/Clinic Name'**
  String get editDoctorHospital;

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

  /// No description provided for @editDoctorLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get editDoctorLatitude;

  /// No description provided for @editDoctorLicense.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get editDoctorLicense;

  /// No description provided for @editDoctorLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editDoctorLocation;

  /// No description provided for @editDoctorLocationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get editDoctorLocationNotSet;

  /// No description provided for @editDoctorLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected'**
  String get editDoctorLocationSelected;

  /// No description provided for @editDoctorLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get editDoctorLongitude;

  /// No description provided for @editDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editDoctorName;

  /// No description provided for @editDoctorPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get editDoctorPersonalInfo;

  /// No description provided for @editDoctorPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editDoctorPhone;

  /// No description provided for @editDoctorProfessionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get editDoctorProfessionalInfo;

  /// No description provided for @editDoctorProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get editDoctorProfilePicture;

  /// No description provided for @editDoctorQualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get editDoctorQualification;

  /// No description provided for @editDoctorRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get editDoctorRequiredField;

  /// No description provided for @editDoctorReturningFee.
  ///
  /// In en, this message translates to:
  /// **'Returning Fees'**
  String get editDoctorReturningFee;

  /// No description provided for @editDoctorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editDoctorSave;

  /// No description provided for @editDoctorSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Select a Day'**
  String get editDoctorSelectDay;

  /// No description provided for @editDoctorSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location from Map'**
  String get editDoctorSelectLocation;

  /// No description provided for @editDoctorSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get editDoctorSpecialization;

  /// No description provided for @editDoctorStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get editDoctorStartTime;

  /// No description provided for @editDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editDoctorTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @ent.
  ///
  /// In en, this message translates to:
  /// **'ENT (Ear, Nose, and Throat)'**
  String get ent;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// No description provided for @errorCreatingDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Error creating discount code'**
  String get errorCreatingDiscountCode;

  /// No description provided for @errorDeletingCode.
  ///
  /// In en, this message translates to:
  /// **'Error deleting code'**
  String get errorDeletingCode;

  /// No description provided for @errorLoadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Error loading Appointments'**
  String get errorLoadingAppointments;

  /// No description provided for @errorLoadingDiscount.
  ///
  /// In en, this message translates to:
  /// **'Error loading discount'**
  String get errorLoadingDiscount;

  /// No description provided for @errorLoadingDoctors.
  ///
  /// In en, this message translates to:
  /// **'Error loading doctors'**
  String get errorLoadingDoctors;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @errorLoadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Error loading statistics'**
  String get errorLoadingStatistics;

  /// No description provided for @errorUpdatingCode.
  ///
  /// In en, this message translates to:
  /// **'Error updating code'**
  String get errorUpdatingCode;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @expiryDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date (Optional)'**
  String get expiryDateOptional;

  /// No description provided for @featureLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'You can\'t use this feature until you log in.'**
  String get featureLoginRequired;

  /// No description provided for @featureNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Review submission not implemented'**
  String get featureNotImplemented;

  /// No description provided for @featuredDoctors.
  ///
  /// In en, this message translates to:
  /// **'Featured Doctors'**
  String get featuredDoctors;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @finalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get finalPrice;

  /// No description provided for @fixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount'**
  String get fixedAmount;

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

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get generalError;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String greeting(Object name);

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @gynecologyAndObstetrics.
  ///
  /// In en, this message translates to:
  /// **'Gynecology & Obstetrics'**
  String get gynecologyAndObstetrics;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hospitalOrClinic.
  ///
  /// In en, this message translates to:
  /// **'Hospital or Clinic'**
  String get hospitalOrClinic;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'how are you today?'**
  String get howAreYou;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In-person'**
  String get inPerson;

  /// No description provided for @internalMedicine.
  ///
  /// In en, this message translates to:
  /// **'Internal Medicine'**
  String get internalMedicine;

  /// No description provided for @ivf.
  ///
  /// In en, this message translates to:
  /// **'IVF (In Vitro Fertilization)'**
  String get ivf;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'اللغة'**
  String get languageArabic;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @loadingPayment.
  ///
  /// In en, this message translates to:
  /// **'Loading payment...'**
  String get loadingPayment;

  /// No description provided for @loadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Loading statistics...'**
  String get loadingStatistics;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location: {error}'**
  String locationError(Object error);

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

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutArabic.
  ///
  /// In en, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutArabic;

  /// No description provided for @manageYourHealthcarePlatform.
  ///
  /// In en, this message translates to:
  /// **'Manage your healthcare platform'**
  String get manageYourHealthcarePlatform;

  /// No description provided for @mapViewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Map view coming soon'**
  String get mapViewComingSoon;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllRead;

  /// No description provided for @maximumDiscountAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 200'**
  String get maximumDiscountAmountHint;

  /// No description provided for @maximumDiscountAmountOptional.
  ///
  /// In en, this message translates to:
  /// **'Maximum Discount Amount (Optional)'**
  String get maximumDiscountAmountOptional;

  /// No description provided for @minimumOrderAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100'**
  String get minimumOrderAmountHint;

  /// No description provided for @minimumOrderAmountOptional.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Amount (Optional)'**
  String get minimumOrderAmountOptional;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @moveToApproved.
  ///
  /// In en, this message translates to:
  /// **'Move to Approved'**
  String get moveToApproved;

  /// No description provided for @moveToRejected.
  ///
  /// In en, this message translates to:
  /// **'Move to Rejected'**
  String get moveToRejected;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @neurology.
  ///
  /// In en, this message translates to:
  /// **'Neurology'**
  String get neurology;

  /// No description provided for @newBooking.
  ///
  /// In en, this message translates to:
  /// **'New Booking'**
  String get newBooking;

  /// No description provided for @noAppointmentsForThisDay.
  ///
  /// In en, this message translates to:
  /// **'لا توجد مواعيد لهذا اليوم'**
  String get noAppointmentsForThisDay;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No appointments today'**
  String get noAppointmentsToday;

  /// No description provided for @noAppointmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No Appointments Yet'**
  String get noAppointmentsYet;

  /// No description provided for @noApprovedDoctors.
  ///
  /// In en, this message translates to:
  /// **'No approved doctors'**
  String get noApprovedDoctors;

  /// No description provided for @noBookmarkedDoctorsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookmarked doctors yet'**
  String get noBookmarkedDoctorsYet;

  /// No description provided for @noCompletedAppointments.
  ///
  /// In en, this message translates to:
  /// **'No completed appointments'**
  String get noCompletedAppointments;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noDiscountCodesFound.
  ///
  /// In en, this message translates to:
  /// **'No discount codes found'**
  String get noDiscountCodesFound;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @noExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get noExpiryDate;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @noPendingDoctors.
  ///
  /// In en, this message translates to:
  /// **'No pending doctors'**
  String get noPendingDoctors;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @noRejectedDoctors.
  ///
  /// In en, this message translates to:
  /// **'No rejected doctors'**
  String get noRejectedDoctors;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @noStatisticsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No statistics available'**
  String get noStatisticsAvailable;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noUpcomingAppointments;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

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

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rosheta. Your Health, Our Priority'**
  String get onboardingTitle;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcome;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @onlineConsultation.
  ///
  /// In en, this message translates to:
  /// **'Online Consultation'**
  String get onlineConsultation;

  /// No description provided for @ophthalmology.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmology'**
  String get ophthalmology;

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price'**
  String get originalPrice;

  /// No description provided for @orthopedics.
  ///
  /// In en, this message translates to:
  /// **'Orthopedics'**
  String get orthopedics;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @paided.
  ///
  /// In en, this message translates to:
  /// **'paided'**
  String get paided;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Please check your inbox.'**
  String get passwordResetEmailSent;

  /// No description provided for @patientBookedNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'A patient has booked a new appointment, check it now'**
  String get patientBookedNewAppointment;

  /// No description provided for @patientTab.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientTab;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment:'**
  String get payment;

  /// No description provided for @paymentArabic.
  ///
  /// In en, this message translates to:
  /// **'الدفع'**
  String get paymentArabic;

  /// No description provided for @paymentError.
  ///
  /// In en, this message translates to:
  /// **'Payment error occurred'**
  String get paymentError;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @noPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get noPaymentsFound;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccess;

  /// No description provided for @pediatricsAndNeonatology.
  ///
  /// In en, this message translates to:
  /// **'Pediatrics & Neonatology'**
  String get pediatricsAndNeonatology;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @pendingDoctors.
  ///
  /// In en, this message translates to:
  /// **'Pending Doctors'**
  String get pendingDoctors;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @percentageCannotExceed100.
  ///
  /// In en, this message translates to:
  /// **'Percentage cannot exceed 100%'**
  String get percentageCannotExceed100;

  /// No description provided for @percentUsed.
  ///
  /// In en, this message translates to:
  /// **'% used'**
  String get percentUsed;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @personalDataArabic.
  ///
  /// In en, this message translates to:
  /// **'البيانات الشخصية'**
  String get personalDataArabic;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneNumberOptional;

  /// No description provided for @physiotherapy.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy'**
  String get physiotherapy;

  /// No description provided for @pleaseEnterDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a discount code'**
  String get pleaseEnterDiscountCode;

  /// No description provided for @pleaseEnterDiscountName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a discount name'**
  String get pleaseEnterDiscountName;

  /// No description provided for @pleaseEnterDiscountValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter discount value'**
  String get pleaseEnterDiscountValue;

  /// No description provided for @pleaseEnterUsageLimit.
  ///
  /// In en, this message translates to:
  /// **'Please enter usage limit'**
  String get pleaseEnterUsageLimit;

  /// No description provided for @pleaseEnterValidPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number'**
  String get pleaseEnterValidPositiveNumber;

  /// No description provided for @pleaseRate.
  ///
  /// In en, this message translates to:
  /// **'Please make sure a rate and write a review first'**
  String get pleaseRate;

  /// No description provided for @pleaseReviewTheAppointmentDetailsBeforeConfirming.
  ///
  /// In en, this message translates to:
  /// **'Please review the appointment details before confirming:'**
  String get pleaseReviewTheAppointmentDetailsBeforeConfirming;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyArabic.
  ///
  /// In en, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicyArabic;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund and Policy'**
  String get refundPolicy;

  /// No description provided for @refundPolicyArabic.
  ///
  /// In en, this message translates to:
  /// **'سياسة الاسترداد'**
  String get refundPolicyArabic;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @qualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualification;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @ratingPercentage.
  ///
  /// In en, this message translates to:
  /// **'{percentage}%'**
  String ratingPercentage(Object percentage);

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @rejectDoctor.
  ///
  /// In en, this message translates to:
  /// **'Reject Doctor'**
  String get rejectDoctor;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @rejectedDoctors.
  ///
  /// In en, this message translates to:
  /// **'Rejected Doctors'**
  String get rejectedDoctors;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @removeVip.
  ///
  /// In en, this message translates to:
  /// **'Remove VIP'**
  String get removeVip;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @returning.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Visit'**
  String get returning;

  /// No description provided for @returningDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow-up visit for existing treatment'**
  String get returningDescription;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(Object count);

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String roleLabel(Object role);

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save Location'**
  String get saveLocation;

  /// No description provided for @scheduledAppointment.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Appointment'**
  String get scheduledAppointment;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchDiscountCodes.
  ///
  /// In en, this message translates to:
  /// **'Search discount codes...'**
  String get searchDiscountCodes;

  /// No description provided for @searchHere.
  ///
  /// In en, this message translates to:
  /// **'ابحث هنا'**
  String get searchHere;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search doctors, medicines etc...'**
  String get searchPlaceholder;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'اختر وسيله الدفع'**
  String get select;

  /// No description provided for @selectAppointmentType.
  ///
  /// In en, this message translates to:
  /// **'Select Appointment Type'**
  String get selectAppointmentType;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectedLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocationTitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocationTitle;

  /// No description provided for @selectProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Photo'**
  String get selectProfilePhoto;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareYourExperience;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

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

  /// No description provided for @signInEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signInEmailHint;

  /// No description provided for @signInEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInEmailLabel;

  /// No description provided for @signInPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get signInPasswordHint;

  /// No description provided for @signInPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPasswordLabel;

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

  /// No description provided for @signInRequiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your profile and access all features.'**
  String get signInRequiredSubtitle;

  /// No description provided for @signInRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In Required'**
  String get signInRequiredTitle;

  /// No description provided for @signout.
  ///
  /// In en, this message translates to:
  /// **'signout'**
  String get signout;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @signUpConfirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'please enter your Confirm Password'**
  String get signUpConfirmPasswordError;

  /// No description provided for @signUpConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordHint;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @signUpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signUpEmailHint;

  /// No description provided for @signUpEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpEmailLabel;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get signUpPasswordHint;

  /// No description provided for @signUpPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPasswordLabel;

  /// No description provided for @signUpPasswordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Password and Confirm Password must be same'**
  String get signUpPasswordMismatchError;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to continue!'**
  String get signUpSubtitle;

  /// No description provided for @signUpTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get signUpTermsLink;

  /// No description provided for @signUpTermsText.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our'**
  String get signUpTermsText;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get signUpTitle;

  /// No description provided for @signUpUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get signUpUsernameHint;

  /// No description provided for @signUpUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get signUpUsernameLabel;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @specializations.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specializations;

  /// No description provided for @specialty_empty.
  ///
  /// In en, this message translates to:
  /// **'No specialty'**
  String get specialty_empty;

  /// No description provided for @specialtyEmpty.
  ///
  /// In en, this message translates to:
  /// **'no specialty selected'**
  String get specialtyEmpty;

  /// No description provided for @speechAndLanguageTherapy.
  ///
  /// In en, this message translates to:
  /// **'Speech and Language Therapy'**
  String get speechAndLanguageTherapy;

  /// No description provided for @startBookmarkingDoctorsToSeeThemHere.
  ///
  /// In en, this message translates to:
  /// **'Start bookmarking doctors to see them here'**
  String get startBookmarkingDoctorsToSeeThemHere;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @termsAndConditionsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions'**
  String get termsAndConditionsError;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeArabic.
  ///
  /// In en, this message translates to:
  /// **'تغيير المظهر'**
  String get themeArabic;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @todaysAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get todaysAppointments;

  /// No description provided for @todaysRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get todaysRevenue;

  /// No description provided for @topDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Doctors'**
  String get topDoctors;

  /// No description provided for @topRatedDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Doctors'**
  String get topRatedDoctors;

  /// No description provided for @totalAppointments.
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get totalAppointments;

  /// No description provided for @totalCodes.
  ///
  /// In en, this message translates to:
  /// **'Total Codes'**
  String get totalCodes;

  /// No description provided for @totalDoctors.
  ///
  /// In en, this message translates to:
  /// **'Total Doctors'**
  String get totalDoctors;

  /// No description provided for @totalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get totalPatients;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @tryCatchAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get tryCatchAuthFailed;

  /// No description provided for @tryCatchEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get tryCatchEmailInUse;

  /// No description provided for @tryCatchGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get tryCatchGenericError;

  /// No description provided for @tryCatchInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get tryCatchInvalidCredential;

  /// No description provided for @tryCatchInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get tryCatchInvalidEmail;

  /// No description provided for @tryCatchNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get tryCatchNetworkError;

  /// No description provided for @tryCatchOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed. Please try again later.'**
  String get tryCatchOperationNotAllowed;

  /// No description provided for @tryCatchRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'This operation is sensitive and requires recent authentication. Please log in again before retrying this request.'**
  String get tryCatchRequiresRecentLogin;

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

  /// No description provided for @tryCatchTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tryCatchTooManyRequests;

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

  /// No description provided for @tryCatchWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please use a stronger password'**
  String get tryCatchWeakPassword;

  /// No description provided for @tryCatchWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get tryCatchWrongPassword;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unknownDoctor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Doctor'**
  String get unknownDoctor;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'unpaid'**
  String get unpaid;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @upcomingAppointmentsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your upcoming appointments will appear here'**
  String get upcomingAppointmentsWillAppearHere;

  /// No description provided for @upgradeToVip.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to VIP'**
  String get upgradeToVip;

  /// No description provided for @urology.
  ///
  /// In en, this message translates to:
  /// **'Urology'**
  String get urology;

  /// No description provided for @usageLimit.
  ///
  /// In en, this message translates to:
  /// **'Usage Limit'**
  String get usageLimit;

  /// No description provided for @usageLimitHelper.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of times this code can be used'**
  String get usageLimitHelper;

  /// No description provided for @usageLimitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100'**
  String get usageLimitHint;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @validatorEmptyField.
  ///
  /// In en, this message translates to:
  /// **'Oops! It looks like you missed this one. Please fill it in.'**
  String get validatorEmptyField;

  /// No description provided for @validatorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validatorEnterEmail;

  /// No description provided for @validatorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validatorEnterPassword;

  /// No description provided for @validatorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validatorInvalidEmail;

  /// No description provided for @validatorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number greater than 0.'**
  String get validatorInvalidNumber;

  /// No description provided for @validatorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters,\ninclude an uppercase letter,\n number, and symbol'**
  String get validatorInvalidPassword;

  /// No description provided for @validatorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Egyptian mobile number (starting with 01 followed by 9 numbers).'**
  String get validatorInvalidPhone;

  /// No description provided for @validatorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get validatorPasswordTooShort;

  /// No description provided for @vascularSurgery.
  ///
  /// In en, this message translates to:
  /// **'Vascular Surgery'**
  String get vascularSurgery;

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

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewChart.
  ///
  /// In en, this message translates to:
  /// **'View Chart'**
  String get viewChart;

  /// No description provided for @viewDetailedAnalyticsAndReports.
  ///
  /// In en, this message translates to:
  /// **'View detailed analytics and reports'**
  String get viewDetailedAnalyticsAndReports;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

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

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @welcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome Admin'**
  String get welcomeAdmin;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeMessage(Object name);

  /// No description provided for @welcomeToYourDashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your dashboard'**
  String get welcomeToYourDashboard;

  /// No description provided for @writeAReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeAReview;

  /// No description provided for @yearsExp.
  ///
  /// In en, this message translates to:
  /// **'years experience'**
  String get yearsExp;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'years experience'**
  String get yearsExperience;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsOfExperience;

  /// No description provided for @youllSeeNotificationsHere.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see notifications here when you receive them'**
  String get youllSeeNotificationsHere;
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
