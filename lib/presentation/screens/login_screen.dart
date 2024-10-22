import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/signup_screen.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/registration_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/title_label.dart';
import '../../core/constants/color_palette.dart';
import '../widgets/input_text_field.dart';


class LoginScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;


  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _authenticateUser() {
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
                  obscureText: _obscurePassword,
                  togglePasswordView: _togglePasswordVisibility,
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
                  child: Text('Not registered yet? Sign Up', style: TextStyle(color: ColorPalette.darkCyan, fontFamily: 'Poppins'),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
