import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:namer_app/models/product.dart';
import 'dart:io';

const String PRODUCT_COLLECTION = 'Produtos';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final CollectionReference _productsRef;

  DatabaseService() {
    _productsRef =
        _firestore.collection(PRODUCT_COLLECTION).withConverter<Product>(
            fromFirestore: (snapshots, _) => Product.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (product, _) => product.toJson());
  }

Stream<List<Product>> getProducts() {
  return _productsRef.snapshots().map(
    (querySnapshot) => querySnapshot.docs.map(
      (doc) => doc.data() as Product, // Directly convert to Product object
    ).toList(),
  );
}


  Stream<List<Product>> getRecommended() {
  return _productsRef.orderBy('score', descending: true).limit(5).snapshots().map(
    (querySnapshot) => querySnapshot.docs.map(
      (doc) => doc.data() as Product,
    ).toList(),
  );
}

Future<void> addProduct(Product product) async {
  try {
    await _productsRef.add(product);
  } catch (error) {
    throw Exception('Failed to add product: $error');
  }
}

Future<String> _uploadImage(File imageFile) async {
    try {
      // Create a reference for the image in Firebase Storage
      Reference ref = _storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the image file to Firebase Storage
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      String imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  Future<String> uploadProductImage(File imageFile) async {
    try {
      // Create a reference for the image in Firebase Storage
      Reference ref = _storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the image file to Firebase Storage
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      String imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      throw Exception('Failed to upload product image: $error');
    }
  }
}
