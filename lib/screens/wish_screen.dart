import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/arrow_back.dart';
import '../Widgets/product_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  static const Color primaryColor = Color(0xFF5C3A1A);
  static const Color bottomBarColor = Color(0xFF1E1E1E);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    try {
      User? user = _auth.currentUser;
      print('Loading wishlist for user: ${user?.uid}');

      if (user != null) {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('wishlist')
            .orderBy('addedAt', descending: true)
            .get();

        print('Found ${snapshot.docs.length} wishlist items');

        if (mounted) {
          setState(() {
            items = snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              print('Wishlist item: $data');
              return {
                'id': doc.id,
                'title': data['title'] ?? '',
                'price': data['price'] ?? '\$0.00',
                'rating': (data['rating'] ?? 0.0).toDouble(),
                'image': data['image'] ?? 'assets/images/home_bild8.jpg',
              };
            }).toList();
            isLoading = false;
          });
        }
      } else {
        print('No user logged in');
        if (mounted) {
          setState(() {
            items = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('wishlist')
            .doc(itemId)
            .delete();

        if (mounted) {
          setState(() {
            items.removeWhere((item) => item['id'] == itemId);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from wishlist'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('Error removing from wishlist: $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadWishlistItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: arrowBackAppBar(context, title: 'Wishlist'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'Wishlist'),
      body: items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to your favorites from product details!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadWishlistItems,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${items.length} item${items.length != 1 ? 's' : ''} in wishlist',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Wishlist'),
                            content: const Text('Remove all items from your wishlist?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Clear All'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          User? user = _auth.currentUser;
                          if (user != null) {
                            try {
                              WriteBatch batch = _firestore.batch();
                              for (var item in items) {
                                batch.delete(_firestore
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('wishlist')
                                    .doc(item['id']));
                              }
                              await batch.commit();

                              if (mounted) {
                                setState(() {
                                  items.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Wishlist cleared'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Error clearing wishlist: $e');
                            }
                          }
                        }
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Stack(
                    children: [
                      ProductCard(
                        title: item['title'],
                        price: item['price'],
                        rating: item['rating'],
                        imagePath: item['image'],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                            onPressed: () => removeFromWishlist(item['id']),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}