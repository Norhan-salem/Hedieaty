import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty_flutter_application/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SignUp integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));
    await tester.pumpAndSettle();

    final nameField = find.widgetWithText(TextField, 'Name');
    final emailField = find.widgetWithText(TextField, 'Email');
    final phoneNumberField = find.widgetWithText(TextField, 'Phone Number');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final confirmPasswordField = find.widgetWithText(TextField, 'Confirm Password');
    final signUpButton = find.text('Sign Up');

    await tester.enterText(nameField, 'Test User');
    await tester.pumpAndSettle();
    await tester.enterText(emailField, 'testuser@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(phoneNumberField, '1234567890');
    await tester.pumpAndSettle();
    await tester.enterText(passwordField, 'Test@1234');
    await tester.pumpAndSettle();
    await tester.enterText(confirmPasswordField, 'Test@1234');
    await tester.pumpAndSettle();
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 10));
    await tester.pumpAndSettle();

    final homeScreen = find.byKey(Key('ProfileIcon'));
    expect(homeScreen, findsOneWidget);

  });
}
