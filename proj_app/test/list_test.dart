import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/List/list.dart';
import 'package:provider/provider.dart';

void main() {
  group('ListProvider', () {
    test('addList should add a new list', () {
      final provider = ListProvider();
      provider.addList('Test List');
      expect(provider.lists.length, 1);
      expect(provider.lists[0].name, 'Test List');
    });

    test('removeList should remove a list at the specified index', () {
      final provider = ListProvider();
      provider.addList('Test List');
      provider.removeList(0);
      expect(provider.lists.length, 0);
    });
  });

  group('ListPage', () {
    testWidgets('should display a list of lists', (WidgetTester tester) async {
      final provider = ListProvider();
      provider.addList('List 1');
      provider.addList('List 2');
      await tester.pumpWidget(
        ChangeNotifierProvider<ListProvider>(
          create: (_) => provider,
          child: MaterialApp(
            home: ListPage(),
          ),
        ),
      );
      expect(find.text('List 1'), findsOneWidget);
      expect(find.text('List 2'), findsOneWidget);
    });
  });

  group('ListForm', () {
    testWidgets('should add a new list when the create button is pressed', (WidgetTester tester) async {
      final provider = ListProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<ListProvider>(
          create: (_) => provider,
          child: MaterialApp(
            home: ListForm(),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'New List');
      await tester.tap(find.text('Create List'));
      await tester.pump();
      expect(provider.lists.length, 1);
      expect(provider.lists[0].name, 'New List');
    });
  });
}