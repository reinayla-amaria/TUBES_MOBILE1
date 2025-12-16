import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court_model.dart';

class ApiService {
  // Ganti dengan IP Address Laptop Anda jika pakai Emulator (jangan 'localhost')
  // Contoh: 'http://192.168.1.10/api_lapangin' atau URL hosting
  static const String baseUrl = 'http://192.168.1.X/api';

  // 1. GET Daftar Lapangan [cite: 473]
  Future<List<Court>> getCourts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courts.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Court.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data lapangan');
      }
    } catch (e) {
      throw Exception('Error Network: $e'); // Handle error network [cite: 475]
    }
  }

  // 2. POST Booking [cite: 474]
  Future<bool> createBooking(
    String courtId,
    String date,
    String time,
    int duration,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'court_id': courtId,
          'date': date,
          'time': time,
          'duration': duration,
          'user_id': '1', // Hardcode dulu atau ambil dari AuthProvider
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error Posting Booking: $e");
      return false;
    }
  }
}
