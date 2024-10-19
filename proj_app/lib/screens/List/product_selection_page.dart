import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/List/list.dart';
import 'package:namer_app/services/database_service.dart';

class ProductSelectionPage extends StatelessWidget {
  final int listIndex;

  ProductSelectionPage({required this.listIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: StreamBuilder<List<Product>>(
        stream: DatabaseService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> products = snapshot.data ?? [];
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      products[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${products[index].price.toStringAsFixed(2)} €'),
                      ],
                    ),
                    trailing: products[index].imageScore != null
                        ? Image.network(products[index].imageScore!, width: 50)
                        : SizedBox(width: 50),
                    onTap: () {
                      Provider.of<ListProvider>(context, listen: false)
                          .addProductToList(listIndex, products[index], context);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
