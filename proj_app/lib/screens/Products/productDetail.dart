import 'package:flutter/material.dart';
import 'package:namer_app/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: product.image != null
                    ? Image.network(
                        product.image!,
                        height: 300, // Aumentando a altura da imagem do produto para dar mais destaque
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Center(child: Text('Error loading image: $error'));
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 300, // Mantendo a altura do placeholder consistente com a imagem do produto
                        color: Colors.grey[300],
                        child: Center(child: Text('No image available', style: TextStyle(color: Colors.grey[700]))),
                      ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${product.price.toStringAsFixed(2)} €',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Origin Country:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.originCountry,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Stores:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.stores,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // Espaçamento entre os detalhes e a imagem do score
                  Container(
                    height: 100, // Mantendo a altura original da imagem do score
                    color: Colors.grey[300],
                    child: Center(
                      child: product.imageScore != null
                          ? Image.network(
                              product.imageScore!,
                              height: 100, // Altura reduzida para a imagem do score
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Center(child: Text('Error loading image: $error'));
                              },
                            )
                          : Text('No score image available', style: TextStyle(color: Colors.grey[700])),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
