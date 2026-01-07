import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseDetailPage extends StatelessWidget {
  final String title;
  final String mentor;
  final String imageUrl;
  final double rating;
  final int students;
  final int price;
  final String description;

  const CourseDetailPage({
    super.key,
    required this.title,
    required this.mentor,
    required this.imageUrl,
    required this.rating,
    required this.students,
    required this.price,
    required this.description,
  });

  // ================= HTTP 1 =================
  Future<void> addToCart(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"course_title": title, "price": price, "qty": 1}),
    );

    if (response.statusCode == 201) {
      CartPage.addItem(title, price);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil ditambahkan ke keranjang")),
      );
    }
  }

  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // TITLE
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(mentor, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(" $rating"),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 18),
                Text(" $students peserta"),
              ],
            ),

            const SizedBox(height: 16),

            // PRICE
            Text(
              "Rp ${price.toString().replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]}.')}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 16),

            // TOMBOL TAMBAH KERANJANG (HTTP + SNACKBAR)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await addToCartHttp();

                  CartPage.addItem(title, price);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Berhasil ditambahkan ke keranjang"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Deskripsi Kursus",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),

            const SizedBox(height: 24),

            const Text(
              "Materi Pembelajaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ExpansionTile(
              title: const Text("Materi 1: Pengenalan Dasar"),
              children: const [ListTile(title: Text("Video + PDF"))],
            ),
            ExpansionTile(
              title: const Text("Materi 2: Implementasi"),
              children: const [ListTile(title: Text("Latihan & Studi Kasus"))],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> addToCartHttp() async {}
