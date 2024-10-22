import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/home_screen.dart';
import 'core/constants/color_palette.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  // Timer(Duration(seconds: 5), (){
  //   FlutterNativeSplash.remove();
  // });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
       theme: ThemeData(
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
      home: HomeScreen(),
    );
  }
}



