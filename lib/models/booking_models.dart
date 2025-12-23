class Booking {
  final String id;
  final String courtName;
  final String date;
  final String time;
  final String status;
  final double totalPrice;

  Booking({
    required this.id,
    required this.courtName,
    required this.date,
    required this.time,
    required this.status,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      courtName: json['court_name'] ?? "Lapangan",
      date: json['booking_date'] ?? json['date'] ?? "",
      time: json['booking_time'] ?? json['time'] ?? "",
      status: json['status'] ?? "Pending",
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
    );
  }
}
