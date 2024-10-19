import 'package:flutter/material.dart';
import 'dart:io';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/home/home.dart';
import 'package:namer_app/services/database_service.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String productName = '';
  double productPrice = 0.0;
  String productOrigin = '';
  int productScore = 0;
  String productStores = '';
  File? _imageFile;
  String productImageScore = '';

  void _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                  onChanged: (value) => productName = value,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) => productPrice = double.parse(value),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Origin Country'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin country';
                    }
                    return null;
                  },
                  onChanged: (value) => productOrigin = value,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Score'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the score';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0 || int.parse(value) > 5) {
                      return 'Please enter a valid score between 0 and 5';
                    }
                    return null;
                  },
                  onChanged: (value) => productScore = int.parse(value),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Stores'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the stores';
                    }
                    return null;
                  },
                  onChanged: (value) => productStores = value,
                ),
                SizedBox(height: 16.0),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 150)
                    : Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                SizedBox(height: 16.0),
                Center(
                  child: TextButton(
                    onPressed: _selectImage,
                    child: Text('Select Image'),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Determine the image score URL based on the score
                        if (productScore > 4) {
                          productImageScore = 'https://firebasestorage.googleapis.com/v0/b/esof-app-60ddf.appspot.com/o/product_images%2F1715734906866?alt=media&token=b82b2a4d-3587-4d52-a848-00a336bc8694';
                        } else if (productScore > 3) {
                          productImageScore = 'https://firebasestorage.googleapis.com/v0/b/esof-app-60ddf.appspot.com/o/product_images%2F1715732392813?alt=media&token=fba8c2b9-4ae7-477b-9d0c-4474a555624d';
                        } else if (productScore > 2) {
                          productImageScore = 'https://firebasestorage.googleapis.com/v0/b/esof-app-60ddf.appspot.com/o/product_images%2F1715732419077?alt=media&token=87320d90-6779-47c7-9e05-b8ec66ce7bc2';
                        } else if (productScore > 1) {
                          productImageScore = 'https://firebasestorage.googleapis.com/v0/b/esof-app-60ddf.appspot.com/o/product_images%2F1715732440732?alt=media&token=2dae7f23-1f2b-435e-a434-5e30ec4e79cc';
                        } else {
                          productImageScore = 'https://firebasestorage.googleapis.com/v0/b/esof-app-60ddf.appspot.com/o/product_images%2F1715732496131?alt=media&token=b1ad110a-dbcf-4419-b17f-d4c4981df47e';
                        }

                        // Create a Product object
                        Product newProduct = Product(
                          name: productName,
                          price: productPrice,
                          originCountry: productOrigin,
                          score: productScore,
                          stores: productStores,
                          image: _imageFile != null ? await DatabaseService().uploadProductImage(_imageFile!) : null,
                          imageScore: productImageScore,
                        );

                        // Add the product to the database
                        try {
                          await DatabaseService().addProduct(newProduct);
                          // Show success message or navigate back
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Product added successfully!'),
                          ));
                          // Navigate to the home page after adding successfully
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AppHomePage()),
                          );
                        } catch (error) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to add product: $error'),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 148, 176, 116), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text('Add Product', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
