
import 'package:alagy/core/helpers/app_regex.dart';

String? emptyValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Oops! It looks like you missed this one. Please fill it in.";
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
    return "Please enter a valid Egyptian mobile number (starting with 01 followed by 9 numbers).";
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
    return "Please enter a valid number greater than 0.";
  }
  return null;
}

String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // RegEx to validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Validation passed
  }
  
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
    return 'Password must be at least 8 characters,\ninclude an uppercase letter,\n number, and symbol';
  }
  return null;
 }