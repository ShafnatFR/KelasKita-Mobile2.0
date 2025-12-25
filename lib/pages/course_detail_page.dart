import 'package:flutter/material.dart';
import 'modules_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // HEADER: SliverAppBar dengan penanganan error gambar
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl, 
                fit: BoxFit.cover,
                // PERBAIKAN: Menangani jika gambar sampul gagal dimuat
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blue.shade100,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.blue),
                  );
                },
              ),
              title: Text(
                title, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(mentor, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(" $rating"),
                      const SizedBox(width: 16),
                      const Icon(Icons.people),
                      Text(" $students peserta"),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pendaftaran kursus berhasil diproses!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Daftar Sekarang", 
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text("Deskripsi Kursus", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 30),
                  const Text("Materi Pembelajaran", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ModulesPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Lihat Semua Modul", 
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildAccordion(),
                  const SizedBox(height: 30),
                  const Text("Ulasan Pelajar", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  
                  // Ulasan dengan avatar yang sudah aman dari error
                  _reviewItem("Jonathan", 5, "Kursus sangat bagus dan mudah dipahami!"),
                  _reviewItem("Amanda", 4, "Penjelasan cukup detail."),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordion() {
    return ExpansionPanelList.radio(
      children: [
        ExpansionPanelRadio(
          value: 1,
          headerBuilder: (context, isOpen) => const ListTile(title: Text("Materi 1: Pengenalan Dasar")),
          body: const ListTile(title: Text("Video + PDF materi")),
        ),
        ExpansionPanelRadio(
          value: 2,
          headerBuilder: (context, isOpen) => const ListTile(title: Text("Materi 2: Implementasi")),
          body: const ListTile(title: Text("Video latihan + contoh kode")),
        ),
      ],
    );
  }

  Widget _reviewItem(String name, int rate, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade50,
                child: ClipOval(
                  child: Image.network(
                    "https://avatar.iran.liara.run/public/girl?username=$name",
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    // Penanganan error statusCode: 0 (CORS)
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.blue);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: List.generate(rate, (_) => const Icon(Icons.star, color: Colors.amber, size: 18)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment),
        ],
      ),
    );
  }
}