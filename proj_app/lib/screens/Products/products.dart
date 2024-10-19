import 'package:flutter/material.dart';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/Products/productDetail.dart';
import 'package:namer_app/screens/Products/addProduct.dart';
import 'package:namer_app/services/database_service.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: DatabaseService().getRecommended(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Product>? products = snapshot.data;
                  if (products != null && products.isNotEmpty) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(product: products[index]),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 3, 10, 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                products[index].name,
                                style: TextStyle(color: Colors.green[700]),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price: ${products[index].price.toStringAsFixed(2)}€'),
                                ],
                              ),
                              trailing: products[index].imageScore != null
                                  ? Image.network(
                                      products[index].imageScore!,
                                      width: 50,
                                      height: 50,
                                    )
                                  : SizedBox(width: 50, height: 50), // Placeholder if image is null
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No products available'));
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 148, 176, 116), // Set the button color to match the app bar
              ),
              child: Text('Add Product',style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
