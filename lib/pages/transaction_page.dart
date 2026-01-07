import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CartPage.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  int get totalPrice {
    return CartPage.cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.qty,
    );
  }

  //HTTP POST TRANSAKSI
  Future<void> submitTransaction(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": 1,
        "total_price": totalPrice,
        "items": CartPage.cartItems
            .map((e) => {"title": e.title, "price": e.price, "qty": e.qty})
            .toList(),
        "payment_method": "transfer",
      }),
    );

    if (response.statusCode == 201) {
      CartPage.cartItems.clear();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Transaksi Berhasil"),
          content: const Text("Pesanan kamu sedang diproses"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        children: [
          // ===== ALAMAT =====
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Rei Ageng\nJl. Contoh No.123\nIndonesia",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ===== LIST ITEM =====
          Expanded(
            child: ListView.builder(
              itemCount: CartPage.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartPage.cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(item.title),
                  subtitle: Text("Qty: ${item.qty}"),
                  trailing: Text(
                    "Rp ${item.price * item.qty}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),

          // ===== RINGKASAN =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                _row("Subtotal", totalPrice),
                _row("Biaya Layanan", 0),
                const Divider(),
                _row("Total", totalPrice, bold: true),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => submitTransaction(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Bayar Sekarang (Rp $totalPrice)",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "Rp $value",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
