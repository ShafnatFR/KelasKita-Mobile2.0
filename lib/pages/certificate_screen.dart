import 'package:flutter/material.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  // Fungsi untuk menampilkan Bottom Sheet Berbagi
  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Tinggi sesuai isi
            children: [
              // Indikator garis kecil di atas sheet agar estetik
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Bagikan Sertifikat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // OPSI 1: Salin Link
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.link, color: Colors.blue),
                ),
                title: const Text("Salin Link", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context); // Tutup sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Link sertifikat berhasil disalin!")),
                  );
                },
              ),

              // OPSI 2: Berbagi ke WA (Sempurna di bawah Salin Link)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.chat, color: Colors.green), // Representasi WA
                ),
                title: const Text("Berbagi ke WA", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context); // Tutup sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mengarahkan ke WhatsApp...")),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Sertifikat", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // DESAIN SERTIFIKAT CUSTOM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade900, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), 
                    blurRadius: 15, 
                    offset: const Offset(0, 5)
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text("SERTIFIKAT KELULUSAN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 15),
                  const Text("Diberikan Kepada:", style: TextStyle(fontStyle: FontStyle.italic)),
                  const Text("NADIA SYAHIDA RAHMI", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text("Atas penyelesaian kursus:"),
                  const Text("DASAR PEMROGRAMAN PERANGKAT BERGERAK", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text("DPPB Team", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text("Sertifikat Digital", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            
            // Tombol Download
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sertifikat berhasil diunduh!"))
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text("Download Sertifikat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),
            
            // Tombol Opsi Berbagi
            SizedBox(
              width: double.infinity, height: 55,
              child: OutlinedButton.icon(
                onPressed: () => _showShareBottomSheet(context), // Memanggil fungsi sheet
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                icon: const Icon(Icons.share),
                label: const Text("Opsi Berbagi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}