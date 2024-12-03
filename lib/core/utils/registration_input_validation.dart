
class RegistrationInputValidation {
  static bool isEmailValid(String email) {
  // email validation regex
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
  // Check for at least 8 characters, one uppercase, one lowercase, and one number
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
  return passwordRegex.hasMatch(password);
  }

  static bool isNameValid(String name) {
    // Check if name contains at least 3 letters
    return name.length >= 3 && RegExp(r'^[a-zA-Z]+').hasMatch(name);
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
  return password == confirmPassword;
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+\d{1,3}\d{9,}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}

