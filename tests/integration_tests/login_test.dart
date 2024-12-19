import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty_flutter_application/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));
    await tester.pumpAndSettle();

    final loginLink = find.byType(TextButton);
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    final loginButton = find.byType(ElevatedButton);

    expect(loginLink, findsOneWidget);

    await tester.tap(loginLink);
    await tester.pumpAndSettle();

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'nado@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(passwordField, 'norhanA1');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 10));
    await tester.pumpAndSettle();

    final homeScreen = find.byKey(Key('ProfileIcon'));
    expect(homeScreen, findsOneWidget);
  });
}
