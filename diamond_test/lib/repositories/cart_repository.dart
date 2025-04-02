import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diamond.dart';

class CartRepository {
  static const String _cartKey = 'diamond_cart';

  // Get diamonds from cart
  Future<List<Diamond>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    return cartJson.map((item) => Diamond.fromJson(jsonDecode(item))).toList();
  }

  // Add diamond to cart
  Future<void> addToCart(Diamond diamond) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    // Check if diamond already exists in cart
    for (var item in cartJson) {
      final decodedItem = jsonDecode(item);
      if (decodedItem['lotId'] == diamond.lotId) {
        return; // Diamond already in cart
      }
    }

    // Add diamond to cart
    cartJson.add(jsonEncode(diamond.toJson()));
    await prefs.setStringList(_cartKey, cartJson);
  }

  // Remove diamond from cart
  Future<void> removeFromCart(String lotId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    cartJson.removeWhere((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['lotId'] == lotId;
    });

    await prefs.setStringList(_cartKey, cartJson);
  }

  // Check if diamond is in cart
  Future<bool> isInCart(String lotId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    for (var item in cartJson) {
      final decodedItem = jsonDecode(item);
      if (decodedItem['lotId'] == lotId) {
        return true;
      }
    }

    return false;
  }
}
