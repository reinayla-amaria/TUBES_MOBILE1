import 'package:flutter/material.dart';
import '../../models/court_model.dart';
import 'payment_screen.dart';

class BookingScheduleScreen extends StatefulWidget {
  final Court court;
  const BookingScheduleScreen({super.key, required this.court});

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  // --- STATE VARIABLES ---
  String? _selectedField;
  String? _selectedTime;
  int? _selectedDate; // Menyimpan tanggal yang dipilih (misal: 10)

  // Data Dummy untuk Dropdown
  final List<String> fieldList = ['Lapangan 1', 'Lapangan 2', 'Lapangan 3'];
  final List<String> timeList = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '16:00 - 17:00',
    '19:00 - 20:00',
  ];

  // Cek apakah semua form sudah diisi
  bool get _isFormValid =>
      _selectedField != null && _selectedTime != null && _selectedDate != null;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const accentGreen = Color(0xFF00C853);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 24,
              right: 24,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo_white.png', height: 35),
                    const SizedBox(width: 10),
                    const Text(
                      "Lapangin.Aja",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true, // Search bar hiasan
                  decoration: InputDecoration(
                    hintText: "cari lapangan",
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.search, size: 28),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. KONTEN
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Jadwal Lapangan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info & Dropdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.court.imageUrl,
                          width: 150,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, __) => Container(
                            width: 150,
                            height: 110,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildDropdown(
                              "Lapangan",
                              fieldList,
                              _selectedField,
                              (val) {
                                setState(() => _selectedField = val);
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildDropdown("Waktu", timeList, _selectedTime, (
                              val,
                            ) {
                              setState(() => _selectedTime = val);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // KALENDER INTERAKTIF
                  _buildInteractiveCalendar(),

                  const SizedBox(height: 20),

                  // TOMBOL BOOKING (Dengan Validasi)
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 180, // Lebar tombol
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Jika valid warna Hijau/Biru, jika tidak Abu-abu
                          backgroundColor: _isFormValid
                              ? accentGreen
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: _isFormValid ? 2 : 0,
                        ),
                        // Jika tidak valid, onPressed null (tombol mati)
                        onPressed: _isFormValid
                            ? () {
                                _processBooking();
                              }
                            : null,
                        child: const Text(
                          "Booking Sekarang",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi Navigasi ke Pembayaran
  void _processBooking() {
    // Hitung total harga (Dummy logic: 1 jam)
    double total = widget.court.pricePerHour * 1;

    // Kirim data ke Payment Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          // Buat Booking ID dummy atau ambil dari backend nanti
          bookingId:
              "BOOK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
          court: widget.court,
          date: "2023-12-$_selectedDate",
          time: _selectedTime!,
          totalPrice: total,
        ),
      ),
    );
  }

  // Widget Dropdown
  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Widget Kalender (Bisa Diklik)
  Widget _buildInteractiveCalendar() {
    final List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    // Data visual kalender
    final List<int> dates = [
      30, // Prev Month
      1, 2, 3, 4, 5, 6,
      7, 8, 9, 10, 11, 12, 13,
      14, 15, 16, 17, 18, 19, 20,
      21, 22, 23, 24, 25, 26, 27,
      28, 29, 30, 31,
      1, 2, 3, // Next Month
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header Hari
          Row(
            children: days
                .map(
                  (day) => Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        day,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          // Grid Tanggal
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final date = dates[index];

              // Logika visual sederhana untuk membedakan bulan ini dan bulan lain
              bool isCurrentMonth = index > 0 && index <= 31;
              bool isSelected = isCurrentMonth && _selectedDate == date;

              return InkWell(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          _selectedDate = date; // Set tanggal yang dipilih
                        });
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: isSelected
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            )
                          : null,
                      alignment: Alignment.center,
                      child: Text(
                        "$date",
                        style: TextStyle(
                          color: !isCurrentMonth
                              ? Colors.grey[300]
                              : (isSelected ? Colors.blue : Colors.black87),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
