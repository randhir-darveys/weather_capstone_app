import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_capstone_app/app.dart';

void main() {
  testWidgets('Bottom navigation changes screens correctly', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const WeatherCapstoneApp());

    await tester.pump();

    expect(find.text('Weather Home'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Search City'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsWidgets);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text('About App'), findsOneWidget);
  });
}