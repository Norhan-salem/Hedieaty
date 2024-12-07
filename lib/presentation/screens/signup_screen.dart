import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/registration_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/title_label.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/password_visibility_utils.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/authentication_service.dart';
import '../state/registration_state.dart';
import '../widgets/credentials_input_text_field.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final PasswordVisibilityController _passwordVisibilityController =
      PasswordVisibilityController(true);
  final PasswordVisibilityController _confirmPasswordVisibilityController =
      PasswordVisibilityController(true);

  final RegistrationState _registrationState = RegistrationState();
  final AuthService _authService = AuthService();

  void _registerUser() async {
    _registrationState.updateName(_nameController.text);
    _registrationState.updateEmail(_emailController.text);
    _registrationState.updatePassword(_passwordController.text);
    _registrationState.updatePhoneNumber(_phoneNumberController.text);
    _registrationState.updateConfirmPassword(_confirmPasswordController.text);

    if (_registrationState.isValid()) {
      try {
        final firebaseUser = await _authService.registerUser(
          _emailController.text,
          _passwordController.text,
        );

        if (firebaseUser != null) {
          final localUser = User(
            id: firebaseUser.uid,
            username: _nameController.text,
            email: _emailController.text,
            phoneNumber: _phoneNumberController.text,
            isDeleted: false,
            password: _passwordController.text,
          );

          await UserRepository().createUser(localUser);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/registration_bg.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
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
                  label: 'Phone Number',
                  controller: _phoneNumberController,
                  leadingIcon: Icons.call_outlined,
                  errorText: _registrationState.phoneNumberError,
                  onChanged: (value) =>
                      _registrationState.updatePhoneNumber(value),
                ),
                SizedBox(height: 16),
                InputTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _passwordVisibilityController.obscureText,
                  togglePasswordView: () {
                    _passwordVisibilityController.toggleVisibility(() {
                      setState(() {
                        _passwordVisibilityController.obscureText =
                            !_passwordVisibilityController.obscureText;
                      });
                    });
                  },
                  leadingIcon: Icons.lock_outline,
                  errorText: _registrationState.passwordError,
                  onChanged: (value) =>
                      _registrationState.updatePassword(value),
                ),
                SizedBox(height: 16),
                InputTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: _confirmPasswordVisibilityController.obscureText,
                  togglePasswordView: () {
                    _confirmPasswordVisibilityController.toggleVisibility(() {
                      setState(() {
                        _confirmPasswordVisibilityController.obscureText =
                            !_confirmPasswordVisibilityController.obscureText;
                      });
                    });
                  },
                  leadingIcon: Icons.lock_outlined,
                  errorText: _registrationState.confirmPasswordError,
                  onChanged: (value) =>
                      _registrationState.updateConfirmPassword(value),
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
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Already have an account? Log In',
                    style: TextStyle(
                        color: ColorPalette.darkCyan, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
