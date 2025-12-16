import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'booking_screen.dart'; // Halaman Pilih Venue (Daftar Lapangan)

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0; // Menyimpan status menu mana yang sedang aktif

  // Daftar Halaman yang akan ditampilkan sesuai menu yang dipilih
  final List<Widget> _pages = [
    const HomeScreen(), // Index 0: Halaman Utama
    const BookingScreen(), // Index 1: Halaman Booking (Pilih Venue)
    const Center(child: Text("Halaman Chat")), // Index 2: Placeholder Chat
    const Center(
      child: Text("Halaman Profile"),
    ), // Index 3: Placeholder Profile
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    return Scaffold(
      // Body akan berubah sesuai _selectedIndex
      body: _pages[_selectedIndex],

      // Navigasi Bawah
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          showSelectedLabels: false, // Sesuai desain (tanpa label teks)
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Ganti halaman saat icon diklik
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_tennis, size: 30),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 28),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
