import 'package:flutter/material.dart';

class PasswordVisibilityController {
  bool obscureText;

  PasswordVisibilityController(this.obscureText);

  void toggleVisibility(VoidCallback setStateCallback) {
    setStateCallback();
  }
}
