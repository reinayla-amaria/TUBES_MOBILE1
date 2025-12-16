import 'package:flutter/material.dart';
import '../models/court_model.dart';
import '../services/api_services.dart';

class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Court> _courts = [];
  List<Court> get courts => _courts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Fetch Data Lapangan dari API
  Future<void> fetchCourts() async {
    _isLoading = true;
    _errorMessage = ''; // Reset error
    notifyListeners(); // Update UI jadi loading

    try {
      _courts = await _apiService.getCourts();
    } catch (e) {
      _errorMessage = e.toString();
      _courts = []; // Kosongkan data jika error
    }

    _isLoading = false;
    notifyListeners(); // Update UI selesai loading/error
  }

  // Create Booking ke API
  Future<bool> createBooking(
    String courtId,
    DateTime date,
    String time,
    int duration,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Format tanggal ke string yang diterima database (YYYY-MM-DD)
    String dateString = date.toIso8601String().split('T')[0];

    bool success = await _apiService.createBooking(
      courtId,
      dateString,
      time,
      duration,
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
