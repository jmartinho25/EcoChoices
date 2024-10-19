import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/screens/Products/addProduct.dart';

void main() {
  testWidgets('AddProductPage - Widget Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: AddProductPage()));

    // Verify the initial state
    expect(find.text('Add Product'), findsOneWidget);
    expect(find.text('Product Name'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Origin Country'), findsOneWidget);
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('Stores'), findsOneWidget);
    expect(find.text('No image selected'), findsOneWidget);
    expect(find.text('Select Image'), findsOneWidget);
    expect(find.text('Add Product'), findsOneWidget);

    // Enter values in the form fields
    await tester.enterText(find.byKey(ValueKey('productName')), 'Test Product');
    await tester.enterText(find.byKey(ValueKey('productPrice')), '9.99');
    await tester.enterText(find.byKey(ValueKey('productOrigin')), 'Test Country');
    await tester.enterText(find.byKey(ValueKey('productScore')), '4');
    await tester.enterText(find.byKey(ValueKey('productStores')), 'Test Stores');

    // Tap the select image button
    await tester.tap(find.text('Select Image'));
    await tester.pump();

    // Verify the selected image
    expect(find.byType(Image), findsOneWidget);

    // Tap the add product button
    await tester.tap(find.text('Add Product'));
    await tester.pump();

    // Verify the success message
    expect(find.text('Product added successfully!'), findsOneWidget);
  });
}