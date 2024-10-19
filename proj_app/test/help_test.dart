import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/screens/help/help.dart';

void main() {
  testWidgets('HelpPage displays correct title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    expect(find.text('Help'), findsOneWidget);
  });

  testWidgets('HelpPage displays correct number of tiles', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    expect(find.byType(ListTile), findsNWidgets(HelpPage.tiles.length));
  });

  testWidgets('HelpPage shows correct tile titles', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    for (var title in HelpPage.tiles) {
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('HelpPage shows correct tile icons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    for (var icon in HelpPage.icons) {
      expect(find.byIcon(icon), findsOneWidget);
    }
  });

  testWidgets('HelpPage shows about us dialog when tile is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    await tester.tap(find.text(HelpPage.tiles[0]));
    await tester.pumpAndSettle();

    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('...'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('HelpPage shows how to use dialog when tile is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HelpPage()));

    await tester.tap(find.text(HelpPage.tiles[1]));
    await tester.pumpAndSettle();

    expect(find.text('How to Use'), findsOneWidget);
    expect(find.text('1. Organize your shopping list:'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });
}