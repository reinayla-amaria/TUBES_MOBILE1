class BookingHistory {
  final String id;
  final String courtName;
  final String date;
  final String time;
  final String status;
  final double totalPrice;

  BookingHistory({
    required this.id,
    required this.courtName,
    required this.date,
    required this.time,
    required this.status,
    required this.totalPrice,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      id: json['id'].toString(),
      courtName: json['court_name'] ?? '-',
      date: json['date'] ?? '-',
      time: json['time'] ?? '-',
      status: json['status'] ?? 'Pending',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
    );
  }
}
