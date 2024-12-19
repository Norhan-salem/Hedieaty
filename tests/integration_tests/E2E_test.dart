import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty_flutter_application/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - User Flow', () {
    testWidgets('Login, create event, add gift, and publish', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Step 1: Login
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

      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 7));
      await tester.pumpAndSettle();

      final homeScreen = find.byKey(Key('ProfileIcon'));
      expect(homeScreen, findsOneWidget);

      // Step 2: Navigate to Add Event
      final addEventButton = find.text('Create Your Own Event');
      await tester.ensureVisible(addEventButton);
      await tester.tap(addEventButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();

      final addNewEventButton = find.text('Add New Event');
      await tester.ensureVisible(addNewEventButton);
      await tester.tap(addNewEventButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();

      final eventNameField = find.text('Event Name');
      final eventDescriptionField = find.text('Description');
      final eventLocationField = find.text('Location');
      final eventCategoryDropdown = find.text('Category');
      final eventDatePicker = find.text('Select Date');
      final saveEventButton = find.byKey(Key('Add Event'));

      expect(eventNameField, findsOneWidget);
      expect(eventDatePicker, findsOneWidget);
      expect(eventDescriptionField, findsOneWidget);
      expect(eventLocationField, findsOneWidget);
      expect(eventCategoryDropdown, findsOneWidget);
      expect(saveEventButton, findsOneWidget);

      //await tester.ensureVisible(eventNameField);

      await tester.enterText(eventNameField, 'Birthday Party');
      await tester.pumpAndSettle();
      await tester.enterText(eventDescriptionField, 'A fun birthday event');
      await tester.pumpAndSettle();
      await tester.enterText(eventLocationField, 'Central Park');
      await tester.pumpAndSettle();
      await tester.ensureVisible(saveEventButton);
      await tester.tap(eventCategoryDropdown);
      await tester.pumpAndSettle();
      final categoryOption = find.text('Party').last;
      await tester.tap(categoryOption);
      await tester.pumpAndSettle();

      // Select date
      await tester.tap(eventDatePicker);
      await tester.pumpAndSettle();
      final dateOption = find.text('25');
      await tester.tap(dateOption);
      await tester.pumpAndSettle();

      // Save event
      await tester.tap(saveEventButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Birthday Party'), findsOneWidget);

      final eventTile = find.text('Birthday Party');
      await tester.tap(eventTile);
      await tester.pumpAndSettle();

      // Step 3: Add Gift to Event
      final addGiftButton = find.text('Add New Gift');
      await tester.tap(addGiftButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();

      final giftNameField = find.text('Gift Name');
      final giftDescriptionField = find.text('Description');
      final giftPriceField = find.text('Price');
      final giftCategoryDropdown = find.text('Category');
      final publishGiftButton = find.text('Publish');

      await tester.enterText(giftNameField, 'Toy Car');
      await tester.pumpAndSettle();
      await tester.enterText(giftDescriptionField, 'A cool toy car');
      await tester.pumpAndSettle();
      await tester.enterText(giftPriceField, '25');
      await tester.pumpAndSettle();

      await tester.tap(giftCategoryDropdown);
      await tester.pumpAndSettle();
      final giftCategoryOption = find.text('Toys').last;
      await tester.tap(giftCategoryOption);
      await tester.pumpAndSettle();

      await tester.tap(publishGiftButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Gift published successfully!'), findsOneWidget);
    });
  });
}
