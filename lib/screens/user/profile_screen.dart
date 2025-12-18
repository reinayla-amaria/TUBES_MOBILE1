import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controller input
  final TextEditingController _usernameController =
      TextEditingController(); // BARU: Controller Username
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load Data
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load Username (Default: mahasiswa_oke)
      _usernameController.text =
          prefs.getString('user_username') ?? "mahasiswa_oke";
      _nameController.text =
          prefs.getString('user_name') ?? "Mahasiswa Teladan";
      _emailController.text =
          prefs.getString('user_email') ?? "mahasiswa@email.com";
      _phoneController.text = prefs.getString('user_phone') ?? "08123456789";
      _isLoading = false;
    });
  }

  // Simpan Data
  Future<void> _saveProfileData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    // Simpan Username
    await prefs.setString('user_username', _usernameController.text);
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_phone', _phoneController.text);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Profil Berhasil Disimpan!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _loadProfileData(); // Reset jika batal edit
                  _isEditing = false;
                } else {
                  _isEditing = true;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Foto Profil
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryBlue, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            'assets/images/logo_blue.png',
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- FORM DATA ---

                  // 1. Input Username (BARU)
                  _buildTextField(
                    "Username",
                    _usernameController,
                    Icons.alternate_email,
                    _isEditing,
                  ),
                  const SizedBox(height: 15),

                  // 2. Input Nama
                  _buildTextField(
                    "Nama Lengkap",
                    _nameController,
                    Icons.person,
                    _isEditing,
                  ),
                  const SizedBox(height: 15),

                  // 3. Input Email
                  _buildTextField(
                    "Email",
                    _emailController,
                    Icons.email,
                    _isEditing,
                  ),
                  const SizedBox(height: 15),

                  // 4. Input Telepon
                  _buildTextField(
                    "Nomor Telepon",
                    _phoneController,
                    Icons.phone,
                    _isEditing,
                    isNumber: true,
                  ),

                  const SizedBox(height: 30),

                  // Tombol Aksi
                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _saveProfileData,
                        child: const Text(
                          "SIMPAN PERUBAHAN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text("Keluar Akun"),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isEditable, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          enabled: isEditable,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isEditable ? FontWeight.normal : FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isEditable ? Colors.white : Colors.grey[200],
            prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: isEditable
                  ? const BorderSide(color: Colors.blue)
                  : BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }
}
