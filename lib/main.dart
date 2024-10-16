import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/home_screen.dart';
import 'core/utils/color_palette.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  //FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        // Primary color scheme
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ColorPalette.eggShell,
          secondary: ColorPalette.darkCyan,
          surface: ColorPalette.eggShell,
        ),

        //scaffoldBackgroundColor: ColorPalette.eggShell,

        // App bar styling
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

        // Text theme styles
        // textTheme: TextTheme(
        //   headlineLarge: TextStyle(
        //     fontFamily: 'Rowdies',
        //     fontSize: 28,
        //     color: ColorPalette.darkTeal,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   titleLarge: TextStyle(
        //     fontFamily: 'Rowdies',
        //     fontSize: 22,
        //     color: ColorPalette.darkTeal,
        //   ),
        //   bodyLarge: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 16,
        //     color: ColorPalette.darkTeal,
        //   ),
        //   bodyMedium: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 14,
        //     color: ColorPalette.darkTeal,
        //   ),
        //   labelSmall: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 12,
        //     color: ColorPalette.lightPinkishRed,
        //   ),
        // ),

        // Input decoration for forms
        // inputDecorationTheme: InputDecorationTheme(
        //   filled: true,
        //   fillColor: ColorPalette.eggShell,
        //   focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: ColorPalette.darkCyan, width: 2),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: ColorPalette.darkTeal, width: 1),
        //   ),
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        // ),
      ),
      home: HomeScreen(),
    );
  }
}



