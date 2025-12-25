import 'package:flutter/material.dart';
import 'package:kelaskita_mobile/widgets/custom_buttom_navbar.dart';
import 'home_page.dart';
import 'my_courses_page.dart';
import 'schedule_page.dart';
import 'settings_screen.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.themeNotifier});

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isLoading = false; 
  String name = "Nadia";
  String email = "nadia@gmail.com";
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> fetchUserData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));
      
      // FIX: Cek 'mounted' sebelum memproses data setelah await
      if (!mounted) return;

      if (response.statusCode == 200) {

        debugPrint("Status Code: ${response.statusCode}");
        
        final data = json.decode(response.body);

        debugPrint("Data yang diterima: ${response.body}");

        setState(() {
          name = data['name']; 
          email = data['email'];
          nameController.text = name;
          emailController.text = email;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> saveUserData() async {

    debugPrint("Data yang dikirim: name=${nameController.text}, email=${emailController.text}");

    final response = await http.patch(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      body: {'name': nameController.text, 'email': emailController.text},
    );

    // FIX: Cek 'mounted' sebelum memanggil Snackbar
    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        name = nameController.text;
        email = emailController.text;
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui di server!")),
      );
    }
  }

  void _confirmSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin menyimpan perubahan profil?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              saveUserData();
            }, 
            child: const Text("Ya, Simpan")
          ),
        ],
      ),
    );
  }

  int currentAvatarIndex = 0;
  final List<String> avatarOptions = [
    "https://api.dicebear.com/9.x/avataaars/png?seed=NadiaHijab&top=hijab&clothing=graphicShirt&clothingColor=pink&mouth=smile&skinColor=light",
    "https://api.dicebear.com/9.x/lorelei/png?seed=HappyNadia&mouth=happy&eyes=happy&backgroundColor=b6e3f4",
    "https://avatar.iran.liara.run/public/girl?username=Nadia",
  ];

  String get currentAvatarUrl => avatarOptions[currentAvatarIndex];

  void _changePhoto() {
    setState(() {
      currentAvatarIndex = (currentAvatarIndex + 1) % avatarOptions.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Foto diganti!"), duration: Duration(milliseconds: 500)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(themeNotifier: widget.themeNotifier))),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 4,
        themeNotifier: widget.themeNotifier,
        onTap: (index) {
          if (index == 4) return;
          Widget nextPage = HomePage(themeNotifier: widget.themeNotifier);
          if (index == 2) nextPage = MyCoursesPage(themeNotifier: widget.themeNotifier);
          if (index == 3) nextPage = SchedulePage(themeNotifier: widget.themeNotifier);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
        },
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100, width: 4),
                      color: Colors.grey[200],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        currentAvatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4, bottom: 4,
                    child: Material(
                      color: Colors.blue,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: isEditing ? _changePhoto : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.all(color: Colors.white, width: 2)
                          ),
                          // FIX: Ganti withOpacity ke withValues
                          child: Icon(
                            Icons.camera_alt, 
                            color: isEditing ? Colors.white : Colors.white.withValues(alpha: 0.7), 
                            size: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            isEditing
                ? TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name", 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
                      prefixIcon: const Icon(Icons.person)
                    ),
                  )
                : Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            isEditing
                ? TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email", 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
                      prefixIcon: const Icon(Icons.email)
                    ),
                  )
                : Text(email, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () => isEditing ? _confirmSave() : setState(() => isEditing = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                child: Text(
                  isEditing ? "Save Changes" : "Edit Profile", 
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}