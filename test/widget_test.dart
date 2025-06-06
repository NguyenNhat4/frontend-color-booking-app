// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/auth/repositories/auth_repository.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Create a mock auth repository for testing
    final authRepository = AuthRepository();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authRepository: authRepository));

    // Verify that the app loads (should show loading indicator initially)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
