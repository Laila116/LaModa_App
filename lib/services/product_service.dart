import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  final String id;
  final String title;
  final String price;
  final double rating;
  final String imagePath;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.imagePath,
    this.category = '',
    this.description = '',
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      price: data['price'] ?? '\$0.00',
      rating: (data['rating'] ?? 0.0).toDouble(),
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'rating': rating,
      'imagePath': imagePath,
      'category': category,
      'description': description,
    };
  }
}

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  // Add product to cart
  Future<bool> addToCart(Product product, String size, String color, int quantity) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Check if product already exists in cart
      QuerySnapshot existingItems = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .where('name', isEqualTo: product.title)
          .where('size', isEqualTo: size)
          .limit(1)
          .get();

      if (existingItems.docs.isNotEmpty) {
        // Update quantity
        DocumentSnapshot existingItem = existingItems.docs.first;
        int currentQuantity = existingItem.get('quantity') ?? 1;

        await existingItem.reference.update({
          'quantity': currentQuantity + quantity,
        });
      } else {
        // Add new product
        String cleanPrice = product.price.replaceAll(r'$', '').replaceAll(',', '');
        double priceValue = double.tryParse(cleanPrice) ?? 0.0;

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .add({
          'name': product.title,
          'price': priceValue,
          'size': size,
          'quantity': quantity,
          'image': product.imagePath,
          'color': color,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Add product to wishlist
  Future<bool> addToWishlist(Product product) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Check if already in wishlist
      QuerySnapshot existing = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .where('title', isEqualTo: product.title)
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('wishlist')
            .add({
          'title': product.title,
          'price': product.price,
          'rating': product.rating,
          'image': product.imagePath,
          'addedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  // Remove from wishlist
  Future<bool> removeFromWishlist(Product product) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .where('title', isEqualTo: product.title)
          .limit(1)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(Product product) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .where('title', isEqualTo: product.title)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }

  // Get user cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  // Get user wishlist items
  Future<List<Map<String, dynamic>>> getWishlistItems() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting wishlist items: $e');
      return [];
    }
  }

  // Update cart item quantity
  Future<bool> updateCartItemQuantity(String itemId, int newQuantity) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      if (newQuantity <= 0) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(itemId)
            .delete();
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(itemId)
            .update({'quantity': newQuantity});
      }
      return true;
    } catch (e) {
      print('Error updating cart item: $e');
      return false;
    }
  }

  // Remove cart item
  Future<bool> removeCartItem(String itemId) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(itemId)
          .delete();
      return true;
    } catch (e) {
      print('Error removing cart item: $e');
      return false;
    }
  }
}