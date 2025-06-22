// services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference productsRef = FirebaseFirestore.instance.collection(
    'products',
  );

  Stream<QuerySnapshot> getProductsStream() {
    return productsRef.snapshots();
  }
}
