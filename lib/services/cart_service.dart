class CartItem {
  String name;
  double price;
  String size;
  int quantity;
  String image;

  CartItem({
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.image,
  });
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
  }

  void clearCart() {
    _items.clear();
  }
}
