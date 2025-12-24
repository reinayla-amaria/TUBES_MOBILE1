import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/court_model.dart';
import '../models/booking_models.dart';

class ApiService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Court>> getCourts() async {
    try {
      final data = await supabase.from('courts').select();

      return (data as List).map((json) => Court.fromJson(json)).toList();
    } catch (e) {
      print("Error Supabase Courts: $e");
      return [];
    }
  }

  Future<bool> createBooking(
    String courtId,
    String date,
    String time,
    int duration,
    double totalPrice,
  ) async {
    try {
      await supabase.from('bookings').insert({
        'user_id':
            'user_id_sementara', 
        'court_id': int.parse(courtId),
        'date': date,
        'time': time,
        'duration': duration,
        'total_price': totalPrice,
        'status': 'Pending',
      });
      return true;
    } catch (e) {
      print("Error Supabase Booking: $e");
      return false;
    }
  }

  Future<List<Booking>> getBookings(String userId) async {
    try {
      final data = await supabase
          .from('bookings')
          .select('*, courts(name)')

          .order('created_at', ascending: false);

      return (data as List).map((json) {
        return Booking(
          id: json['id'].toString(),
          courtName: json['courts'] != null
              ? json['courts']['name']
              : 'Lapangan',
          date: json['date'],
          time: json['time'],
          status: json['status'],
          totalPrice: (json['total_price'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      print("Error History: $e");
      return [];
    }
  }
}
