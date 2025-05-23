
import 'package:alagy/core/helpers/app_regex.dart';
import 'package:alagy/core/helpers/global_l10n.dart';

String? emptyValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return GlobalL10n.instance.validatorEmptyField;
  }
  return null;
}

String? phoneValidator(String? value) {
  // Check if the value is empty using isEmptyValidator
  String? emptyValidation = emptyValidator(value);
  if (emptyValidation != null) {
    return emptyValidation;
  }
  if (!AppRegex.isPhoneValid(value!)) {
    return GlobalL10n.instance.validatorInvalidPhone;
  }
  return null;
}

String? numbersValidator(String? value) {
  // Check if the value is empty using isEmptyValidator
  String? emptyValidation = emptyValidator(value);
  if (emptyValidation != null) {
    return emptyValidation;
  }
  if (!AppRegex.isNumber(value!)) {
    return GlobalL10n.instance.validatorInvalidNumber;
  }
  return null;
}

String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return GlobalL10n.instance.validatorEnterEmail;
    }
    // RegEx to validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return GlobalL10n.instance.validatorInvalidEmail;
    }
    return null; // Validation passed
  }
  
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return GlobalL10n.instance.validatorEnterPassword;
  }
  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
    return GlobalL10n.instance.validatorInvalidPassword;
  }
  return null;
 }
 String? convertArabicTimeToEnglish(String arabicTime) {
  // Trim any extra whitespace
  final trimmedTime = arabicTime.trim();
  if(trimmedTime.isEmpty) return null;
  // Define Arabic AM/PM indicators
  const arabicAM = 'ص';
  const arabicPM = 'م';
  
  // Initialize the suffix
  String suffix = '';
  
  // Check for AM/PM and extract the time part
  if (trimmedTime.endsWith(arabicAM)) {
    suffix = 'AM';
    return '${trimmedTime.replaceAll(arabicAM, '').trim()} $suffix';
  } else if (trimmedTime.endsWith(arabicPM)) {
    suffix = 'PM';
    return '${trimmedTime.replaceAll(arabicPM, '').trim()} $suffix';
  }
  
  // Return original string if no AM/PM indicator is found
  return trimmedTime;
}