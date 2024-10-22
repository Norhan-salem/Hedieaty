import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/registration_input_validation.dart';


class RegistrationState extends ChangeNotifier {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? nameError;

  void updateEmail(String value) {
    email = value;
    emailError = RegistrationInputValidation.isEmailValid(value) ? null : 'Invalid email format';
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    passwordError = RegistrationInputValidation.isPasswordValid(value) ? null : 'Password must be at least 8 characters, including one uppercase letter, one lowercase letter, and one number';
    confirmPasswordError = RegistrationInputValidation.doPasswordsMatch(value, confirmPassword) ? null : 'Passwords do not match';
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    confirmPasswordError = RegistrationInputValidation.doPasswordsMatch(password, value) ? null : 'Passwords do not match';
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
    nameError = RegistrationInputValidation.isNameValid(value) ? null : 'Name must be at least 3 letters';
    notifyListeners();
  }

  bool isValid() {
    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        nameError == null;
  }
}


