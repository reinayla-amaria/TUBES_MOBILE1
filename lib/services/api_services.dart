import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court_model.dart';
import '../models/booking_models.dart'; // Pastikan model ini sudah dibuat

class ApiService {
  // Ganti IP ini sesuai dengan IP Laptop Anda (cek 'ipconfig')
  static const String baseUrl = 'http://192.168.1.91/api_tubes';

  // ---------------------------------------------------------------------------
  // 1. GET DAFTAR LAPANGAN (Untuk Home Screen)
  // ---------------------------------------------------------------------------
  Future<List<Court>> getCourts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_courts.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Court.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal memuat data lapangan');
      }
    } catch (e) {
      print("Error Get Courts: $e");
      throw Exception('Error Network: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 2. POST BOOKING (Untuk Booking Screen)
  // ---------------------------------------------------------------------------
  Future<bool> createBooking(
    String courtId,
    String date,
    String time,
    int duration,
    double totalPrice,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'court_id': courtId,
          'date': date,
          'time': time,
          'duration': duration,
          'total_price': totalPrice,
          'user_id':
              '1', // Nanti ganti dengan ID dinamis dari SharedPreferences
        }),
      );

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

  // ---------------------------------------------------------------------------
  // 3. GET RIWAYAT BOOKING (Untuk Menu Jadwal di Home)
  // ---------------------------------------------------------------------------
  Future<List<Booking>> getBookings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_history.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Cek struktur JSON dari get_history.php Anda
        // Jika formatnya { "success": true, "data": [...] }
        if (jsonResponse is Map && jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Booking.fromJson(json)).toList();
        }
        // Jika formatnya langsung List [...]
        else if (jsonResponse is List) {
          return jsonResponse.map((json) => Booking.fromJson(json)).toList();
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error Get Bookings: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 4. UPDATE PROFILE (Untuk Profile Screen)
  // ---------------------------------------------------------------------------
  Future<bool> updateProfile(
    String userId,
    String name,
    String email,
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error Update Profile: $e");
      return false;
    }
  }
}
