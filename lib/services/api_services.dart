import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court_model.dart';

class ApiService {
  // 1. HAPUS SPASI SETELAH http://
  // Pastikan IP Address ini sesuai dengan laptop Anda saat ini (cek ipconfig)
  static const String baseUrl = 'http://192.168.1.22/api_tubes';

  // --- GET DAFTAR LAPANGAN ---
  Future<List<Court>> getCourts() async {
    try {
      // 2. SESUAIKAN NAMA FILE PHP (get_courts.php)
      final response = await http.get(Uri.parse('$baseUrl/get_courts.php'));

      if (response.statusCode == 200) {
        // Parse respon: {"success": true, "data": [...]}
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Court.fromJson(json)).toList();
        } else {
          return []; // Kembalikan list kosong jika success false
        }
      } else {
        throw Exception('Gagal memuat data lapangan');
      }
    } catch (e) {
      print("Error Get Courts: $e");
      throw Exception('Error Network: $e');
    }
  }

  // --- POST BOOKING ---
  Future<bool> createBooking(
    String courtId,
    String date,
    String time,
    int duration,
    double totalPrice, // 3. TAMBAHKAN PARAMETER INI
  ) async {
    try {
      // 2. SESUAIKAN NAMA FILE PHP (create_booking.php)
      final response = await http.post(
        Uri.parse('$baseUrl/create_booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'court_id': courtId,
          'date': date,
          'time': time,
          'duration': duration,
          'total_price': totalPrice, // Kirim harga ke backend
          'user_id':
              '1', // Hardcode sementara (nanti ambil dari SharedPreference)
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error Posting Booking: $e");
      return false;
    }
  }
}
