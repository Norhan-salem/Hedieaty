import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/signup_screen.dart';

import 'core/constants/color_palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: ColorPalette.eggShell,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: ColorPalette.darkCyan,
            fontFamily: 'Poppins',
          ),
          contentTextStyle: TextStyle(
            fontSize: 16,
            color: ColorPalette.darkTeal,
            fontFamily: 'Poppins',
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: ColorPalette.eggShell,
          yearStyle: TextStyle(color: ColorPalette.darkCyan, fontSize: 18, fontFamily: 'Poppins'),
          headerBackgroundColor: ColorPalette.yellowHighlight,
          dayStyle: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
        ),
        scaffoldBackgroundColor: ColorPalette.eggShell,
        progressIndicatorTheme:
            ProgressIndicatorThemeData(color: ColorPalette.darkTeal),
        highlightColor: Colors.teal.withOpacity(0.2),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorPalette.darkTeal,
        ),
        buttonTheme: ButtonThemeData(
          splashColor: ColorPalette.darkCyan,
          highlightColor: ColorPalette.darkCyan,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            splashFactory: InkSplash.splashFactory,
            overlayColor: ColorPalette.darkCyan,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: InkSplash.splashFactory,
            overlayColor: ColorPalette.darkCyan,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            splashFactory: InkSplash.splashFactory,
            overlayColor: ColorPalette.darkCyan,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorPalette.lightYellow,
          foregroundColor: ColorPalette.darkTeal,
          titleTextStyle: TextStyle(
            color: ColorPalette.darkTeal,
            fontFamily: 'Rowdies',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: ColorPalette.darkTeal),
        ),
        fontFamily: 'Poppins',
      ),
      home: SignUpScreen(),
    );
  }
}
