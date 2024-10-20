import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/registration_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/title_label.dart';
import '../../core/constants/color_palette.dart';
import '../state/registration_state.dart';
import '../widgets/input_text_field.dart';
import 'home_screen.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final RegistrationState _registrationState = RegistrationState();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _registerUser() {
    _registrationState.updateName(_nameController.text);
    _registrationState.updateEmail(_emailController.text);
    _registrationState.updatePassword(_passwordController.text);
    _registrationState.updateConfirmPassword(_confirmPasswordController.text);

    if (_registrationState.isValid()) {
      // Proceed with registration
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/registration_bg.png',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                TitleLabel(text: 'Get on Board!'),
                SizedBox(height: 20),
                InputTextField(
                  label: 'Name',
                  controller: _nameController,
                  leadingIcon: Icons.person_2_outlined,
                  errorText: _registrationState.nameError,
                  onChanged: (value) => _registrationState.updateName(value),
                ),
                SizedBox(height: 16),
                InputTextField(
                  label: 'Email',
                  controller: _emailController,
                  leadingIcon: Icons.email_outlined,
                  errorText: _registrationState.emailError,
                  onChanged: (value) => _registrationState.updateEmail(value),
                ),
                SizedBox(height: 16),
                InputTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  togglePasswordView: _togglePasswordVisibility,
                  leadingIcon: Icons.lock_outline,
                  errorText: _registrationState.passwordError,
                  onChanged: (value) => _registrationState.updatePassword(value),
                ),
                SizedBox(height: 16),
                InputTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  togglePasswordView: _toggleConfirmPasswordVisibility,
                  leadingIcon: Icons.lock_outlined,
                  errorText: _registrationState.confirmPasswordError,
                  onChanged: (value) => _registrationState.updateConfirmPassword(value),
                ),
                SizedBox(height: 32),
                RegistrationButton(
                  buttonText: 'Sign Up',
                  onPressed: _registerUser,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Already have an account? Log In',
                    style: TextStyle(color: ColorPalette.darkCyan, fontFamily: 'Poppins'),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



