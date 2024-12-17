import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/signup_screen.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/registration_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/title_label.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/password_visibility_utils.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/authentication_service.dart';
import '../widgets/credentials_input_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PasswordVisibilityController _passwordVisibilityController =
      PasswordVisibilityController(true);

  final AuthService _authService = AuthService();

  void _authenticateUser() async {
    try {
      final user = await _authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      final userId = await UserRepository().fetchCurrentUser();
      print('User fetched from local DB with ID: $userId');

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 200),
                      TitleLabel(text: 'Welcome Back,'),
                      SizedBox(height: 20),
                      InputTextField(
                        label: 'Email',
                        controller: _emailController,
                        leadingIcon: Icons.email_outlined,
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
                      ),
                      SizedBox(height: 32),
                      RegistrationButton(
                        buttonText: 'Login',
                        onPressed: _authenticateUser,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Not registered yet? Sign Up',
                          style: TextStyle(
                            color: ColorPalette.darkCyan,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
