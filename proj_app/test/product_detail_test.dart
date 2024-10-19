import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/Products/productDetail.dart';

void main() {
  testWidgets('ProductDetailPage displays product details', (WidgetTester tester) async {

    final product = Product(
      name: 'Test Product',
      image: 'https://example.com/image.jpg',
      price: 9.99,
      originCountry: 'Test Country',
      stores: 'Test Stores',
      imageScore: 'https://example.com/score.jpg',
      score: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailPage(product: product),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Price:'), findsOneWidget);
    expect(find.text('9.99 €'), findsOneWidget);
    expect(find.text('Origin Country:'), findsOneWidget);
    expect(find.text('Test Country'), findsOneWidget);
    expect(find.text('Stores:'), findsOneWidget);
    expect(find.text('Test Stores'), findsOneWidget);
  });
}