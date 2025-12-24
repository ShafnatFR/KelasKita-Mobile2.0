import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  final String keyword;
  const SearchResultPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Result for \"$keyword\""),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _courseItem("Flutter Beginner", "Angela Yu"),
          _courseItem("Advanced Flutter", "Reso Coder"),
          _courseItem("UI/UX Design", "Sarah Jenkins"),
        ],
      ),
    );
  }

  Widget _courseItem(String title, String mentor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://picsum.photos/100/100",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(mentor,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
