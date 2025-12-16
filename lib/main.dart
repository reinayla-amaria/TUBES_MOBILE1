import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Wajib untuk format tanggal Indo

// --- IMPORTS ---
import 'providers/booking_provider.dart';

// PERBAIKAN: Pastikan path ini benar (sesuai instruksi sebelumnya ada di lib/screens/splash_screen.dart)
import 'screens/splash_screen.dart';

void main() async {
  // 1. Pastikan binding Flutter terinisialisasi sebelum kode lain
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi format tanggal (Locale Indonesia)
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. MultiProvider untuk mendaftarkan semua State Management
    return MultiProvider(
      providers: [
        // Daftarkan BookingProvider agar bisa diakses di seluruh aplikasi
        ChangeNotifierProvider(create: (_) => BookingProvider()),

        // Tambahkan Provider lain di sini jika ada (misal AuthProvider)
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Lapangin.Aja',
        debugShowCheckedModeBanner: false, // Hilangkan banner debug
        // 4. Tema Aplikasi Global
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Gunakan desain Material 3 yang lebih modern
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1565C0), // Biru tua khas Lapangin
            foregroundColor: Colors.white, // Teks putih
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // 5. Halaman Awal
        // Aplikasi dimulai dari Splash Screen
        home: const SplashScreen(),
      ),
    );
  }
}
