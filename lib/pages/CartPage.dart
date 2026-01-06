import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'transaction_page.dart';

class CartItem {
  final String title;
  final int price;
  int qty;

  CartItem({required this.title, required this.price, this.qty = 1});
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static List<CartItem> cartItems = [];

  static void addItem(String title, int price) {
    final index = cartItems.indexWhere((e) => e.title == title);
    if (index >= 0) {
      cartItems[index].qty++;
    } else {
      cartItems.add(CartItem(title: title, price: price));
    }
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  // HTTP 2 — GET CART (SIMULASI)
  Future<void> fetchCart() async {
  final response = await http.get(
    Uri.parse('https://dummyjson.com/carts/1'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    CartPage.cartItems.clear();

    for (var p in data['products']) {
      CartPage.cartItems.add(
        CartItem(
          title: p['title'],
          price: p['price'],
          qty: p['quantity'],
        ),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CartPage.cartItems.isEmpty
              ? const Center(child: Text("Keranjang masih kosong"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: CartPage.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = CartPage.cartItems[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text("Rp ${item.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item.qty > 1) item.qty--;
                                });
                              },
                            ),
                            Text("${item.qty}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => item.qty++);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  CartPage.cartItems.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Item dihapus")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: CartPage.cartItems.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionPage()),
                    );
                  },
            child: Text("Checkout (Rp ${_calculateTotalPrice()})"),
          ),
        ),
      );
    }
    // FUNCTION UNTUK MENGHITUNG TOTAL HARGA
    int _calculateTotalPrice() {
      int total = 0;
      for (var item in CartPage.cartItems) {
        total += item.price * item.qty;
      }
      return total;
    }
  }