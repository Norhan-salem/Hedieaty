import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/signup_screen.dart';
import 'core/constants/color_palette.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.databaseURL = 'https://hedeiaty-a4b2f-default-rtdb.europe-west1.firebasedatabase.app';

  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
       theme: ThemeData(
         highlightColor: Colors.teal.withOpacity(0.2),
         textSelectionTheme: TextSelectionThemeData(
           cursorColor: ColorPalette.darkTeal,
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
      ),
      home: SignUpScreen(),
    );
  }
}



