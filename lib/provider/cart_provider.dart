import 'package:flutter/foundation.dart';

class CartItem {
  final dynamic product;
  int quantity;
  final int stockQuantity; // New property

  CartItem({
    required this.product,
    required this.stockQuantity,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  List<CartItem> cartItems = [];

  void addToCart(dynamic product, int stockQuantity, [int quantity = 1]) {
    final cartItem = cartItems.firstWhere(
      (item) => item.product == product,
      orElse: () {
        final newItem = CartItem(
          product: product,
          stockQuantity: stockQuantity,
          quantity: 0,
        );
        cartItems.add(newItem);
        return newItem;
      },
    );
    cartItem.quantity += quantity;
    if (cartItem.quantity > cartItem.stockQuantity) {
      cartItem.quantity = cartItem.stockQuantity;
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
    notifyListeners();
  }

  void updateQuantity(CartItem cartItem, int newQuantity) {
    if (newQuantity <= cartItem.stockQuantity) {
      cartItem.quantity = newQuantity;
      notifyListeners();
    }
  }

  // void updateQuantity(CartItem cartItem, int newQuantity) {
  //   cartItem.quantity = newQuantity;
  //   notifyListeners();
  // }

  int getTotalPrice() {
   
    
    int total = 0;

    for (final cartItem in cartItems) {
      // double apiValue = double.parse(cartItem.product['product_mrp_pack']);
      // int integerValue = apiValue.toInt();

      double apiValue;
      int integerValue;

      if (cartItem.product['product_mrp_pack'] != null) {
        // If 'product_mrp_pack' is not null, parse its value
        apiValue = double.parse(cartItem.product['product_mrp_pack']);
        integerValue = apiValue.toInt();
      } else {
        // If 'product_mrp_pack' is null, calculate based on 'product_mrp' and 'pack_size'
        double productMRP = double.parse(cartItem.product['product_mrp']);
        int packSize = int.parse(cartItem.product['pack_size']);
        integerValue = (productMRP * packSize).toInt();
      }

      double api2Value = double.parse(cartItem.product['Discount']);
      int discount = api2Value.toInt();

      double discountedPrice = integerValue - (integerValue * discount / 100);
      discountedPrice.roundToDouble().toInt();

      total += integerValue * cartItem.quantity;
    }
    return total;
    
  }

  List<Map<String, dynamic>> getAddedCartItemsWithQuantity() {
    return cartItems.where((cartItem) => cartItem.quantity > 0).map((cartItem) {
      return {
        "product_id": "${cartItem.product['product_id']}",
        "quantity": "${cartItem.quantity}",
      };
    }).toList();
  }

  // int getSubtotal() {
  //   int subtotal = 0;
  //   for (final cartItem in cartItems) {
  //     double apiValue = double.parse(cartItem.product['product_mrp_pack']);
  //     int integerValue = apiValue.toInt();
  //     subtotal += integerValue * cartItem.quantity;
  //   }
  //   return subtotal;
  // }
  int getSubtotal() {
    int subtotal = 0;
    for (final cartItem in cartItems) {
      double apiValue;
      int integerValue;

      if (cartItem.product['product_mrp_pack'] != null) {
        // If 'product_mrp_pack' is not null, parse its value
        apiValue = double.parse(cartItem.product['product_mrp_pack']);
        integerValue = apiValue.toInt();
      } else {
        // If 'product_mrp_pack' is null, calculate based on 'product_mrp' and 'pack_size'
        double productMRP = double.parse(cartItem.product['product_mrp']);
        int packSize = int.parse(cartItem.product['pack_size']);
        integerValue = (productMRP * packSize).toInt();
      }

      subtotal += integerValue * cartItem.quantity;
    }
    return subtotal;
  }

  // int getTotalDiscount() {
  //   int totalDiscount = 0;

  //   for (final cartItem in cartItems) {
  //     double apiValue = double.parse(cartItem.product['product_mrp_pack']);
  //     int integerValue = apiValue.toInt();

  //     double api2Value = double.parse(cartItem.product['Discount']);
  //     int discount = api2Value.toInt();

  //     double discountedPrice = integerValue - (integerValue * discount / 100);
  //     int afterDiscountPrice = discountedPrice.roundToDouble().toInt();

  //     int savedAmount = integerValue - afterDiscountPrice;

  //     totalDiscount += savedAmount * cartItem.quantity;
  //   }
  //   return totalDiscount;
  // }
  int getTotalDiscount() {
    int totalDiscount = 0;

    for (final cartItem in cartItems) {
      double apiValue;
      double api2Value;
      int integerValue = 0;
      int discount = 0;

      if (cartItem.product['product_mrp_pack'] != null) {
        apiValue = double.parse(cartItem.product['product_mrp_pack']);
        integerValue = apiValue.toInt();
      } else {
        double productMRP = double.parse(cartItem.product['product_mrp']);
        int packSize = int.parse(cartItem.product['pack_size']);
        integerValue = (productMRP * packSize).toInt();
      }

      if (cartItem.product['Discount'] != null) {
        api2Value = double.parse(cartItem.product['Discount']);
        discount = api2Value.toInt();
      }

      double discountedPrice = integerValue - (integerValue * discount / 100);
      int afterDiscountPrice = discountedPrice.roundToDouble().toInt();

      int savedAmount = integerValue - afterDiscountPrice;

      totalDiscount += savedAmount * cartItem.quantity;
    }
    return totalDiscount;
  }
}
