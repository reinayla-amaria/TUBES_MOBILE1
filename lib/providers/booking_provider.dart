import 'package:flutter/material.dart';
import '../models/court_model.dart';
import '../models/booking_models.dart'; // Import Model Booking
import '../services/api_services.dart';

class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- DATA LAPANGAN (COURTS) ---
  List<Court> _courts = [];
  List<Court> get courts => _courts;

  // --- DATA BOOKING (JADWAL/RIWAYAT) ---
  List<Booking> _bookings = []; // Variabel baru untuk menampung riwayat
  List<Booking> get bookings => _bookings;

  // --- STATE UMUM ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // 1. FETCH DATA LAPANGAN (Untuk Home Screen)
  Future<void> fetchCourts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _courts = await _apiService.getCourts();
    } catch (e) {
      _errorMessage = e.toString();
      _courts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. FETCH RIWAYAT BOOKING (Untuk Menu Jadwal Kamu)
  Future<void> fetchBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _apiService.getBookings(userId);
    } catch (e) {
      print("Error Fetch Bookings: $e");
      _bookings = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 3. CREATE BOOKING (Untuk Proses Pemesanan)
  Future<bool> createBooking(
    String courtId,
    DateTime date,
    String time,
    int duration,
    double pricePerHour,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Hitung total harga sebelum dikirim
    double totalPrice = pricePerHour * duration;

    // Format tanggal
    String dateString = date.toIso8601String().split('T')[0];

    bool success = await _apiService.createBooking(
      courtId,
      dateString,
      time,
      duration,
      totalPrice,
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
