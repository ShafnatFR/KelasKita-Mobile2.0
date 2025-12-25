import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  // Perbaikan: Menambahkan super.key untuk standar widget publik
  const SettingsScreen({super.key, required this.themeNotifier});

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  String _selectedLanguage = "Bahasa Indonesia";

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Bahasa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Bahasa Indonesia"),
              value: "Bahasa Indonesia",
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text("English"),
              value: "English",
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Preferensi Aplikasi", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
          ),
          const SizedBox(height: 10),
          
          // --- CARD MODE GELAP ---
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.blue),
              title: const Text("Mode Gelap"),
              trailing: Switch(
                value: widget.themeNotifier.value == ThemeMode.dark,
                onChanged: (bool value) {
                  widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                  
                  if (!mounted) return; // Keamanan BuildContext
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tema diganti ke ${value ? 'Mode Gelap' : 'Mode Terang'}"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- CARD NOTIFIKASI (DENGAN SNACKBAR) ---
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text("Notifikasi"),
              subtitle: const Text("Terima update progres belajar"),
              value: _isNotificationEnabled,
              onChanged: (bool value) {
                setState(() => _isNotificationEnabled = value);

                // Menambahkan Snackbar sesuai permintaan Nadia
                if (!mounted) return; 
                ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? "Notifikasi diaktifkan" : "Notifikasi dimatikan"),
                    duration: const Duration(seconds: 1),
                    backgroundColor: value ? Colors.blue.shade700 : Colors.grey.shade800,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Informasi", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
          ),
          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text("Bahasa"),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showLanguageDialog, 
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text("Versi Aplikasi"),
              trailing: Text("1.0.0", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}