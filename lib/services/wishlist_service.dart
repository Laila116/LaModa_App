// file: services/wishlist_service.dart

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final Set<Map<String, dynamic>> _wishlist = {};

  Set<Map<String, dynamic>> get wishlist => _wishlist;

  void addToWishlist(Map<String, dynamic> product) {
    _wishlist.add(product);
  }

  void removeFromWishlist(Map<String, dynamic> product) {
    _wishlist.removeWhere((item) => item['title'] == product['title']);
  }

  bool isInWishlist(Map<String, dynamic> product) {
    return _wishlist.any((item) => item['title'] == product['title']);
  }
}
