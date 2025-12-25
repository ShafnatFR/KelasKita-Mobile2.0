// summary_screen.dart (Versi Zero Problems)
import 'package:flutter/material.dart';
import 'certificate_screen.dart'; 
import 'package:http/http.dart' as http; 

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<List<Map<String, String>>> _fetchFinishedCourses() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=4'));

    // Lihat status code dan body di Debug Console
    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");
    
    if (response.statusCode == 200) {
      final List<String> myCourseNames = ["Basis Data", "Dasar Pemrograman", "Kalkulus", "Pemrograman Web"];

      // --- LOGIKA UNTUK MUNCUL DI DEBUG CONSOLE ---
    debugPrint("--- Daftar Kelas yang Sudah Selesai ---");
    for (var name in myCourseNames) {
      debugPrint("Nama Kelas: $name");
    }
    debugPrint("---------------------------------------");
    
      return List.generate(myCourseNames.length, (index) {
        return {"title": myCourseNames[index], "status": "Selesai"};
      });
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Summary", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView( 
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade600]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sertifikat Telah Diperoleh!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text("Dasar Pemrograman Perangkat Bergerak", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: Colors.blue.shade800, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CertificateScreen())),
                  child: const Text("Lihat Detail"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text("Kelas yang Sudah Selesai", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 10),
          
          FutureBuilder<List<Map<String, String>>>(
            future: _fetchFinishedCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return const Text("Gagal memuat data.");
              
              final data = snapshot.data!;
              return Column(
                children: data.map((course) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardColor, 
                      borderRadius: BorderRadius.circular(14), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05), 
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                      title: Text(course['title']!, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: Text(course['status']!),
                      onTap: () {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Info: ${course['title']} telah selesai.")));
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}