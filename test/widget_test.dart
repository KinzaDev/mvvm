import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/main.dart';
import 'package:mvvm/view/home_screen.dart';
import 'package:mvvm/view/login_screen.dart';
import 'package:mvvm/view/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App renders splash screen and navigates to login when unauthenticated',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    expect(find.text('MVVM Auth App'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('App navigates to HomeScreen when token is present in SharedPreferences',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'token': 'test_token_xyz'});
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Movies List'), findsOneWidget);
  });

  testWidgets('Can navigate from Login to SignUp and back to Login',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(LoginScreen), findsOneWidget);

    // Tap "Don't have an account? Sign Up"
    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is RichText &&
        widget.text.toPlainText().contains('Sign Up')));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpView), findsOneWidget);

    // Tap "Already have an account? Login"
    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is RichText &&
        widget.text.toPlainText().contains('Login')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
