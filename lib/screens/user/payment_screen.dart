import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/court_model.dart';
import 'main_nav_screen.dart'; // Navigasi kembali ke menu utama setelah bayar

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final Court court;
  final String date;
  final String time;
  final double totalPrice;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.court,
    required this.date,
    required this.time,
    required this.totalPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = -1; // -1 artinya belum ada metode yang dipilih

  // Data Dummy Metode Pembayaran
  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 0, 'name': 'BCA Virtual Account', 'icon': Icons.credit_card},
    {'id': 1, 'name': 'BRI Virtual Account', 'icon': Icons.credit_card},
    {'id': 2, 'name': 'GoPay', 'icon': Icons.wallet},
    {'id': 3, 'name': 'Dana', 'icon': Icons.wallet},
    {'id': 4, 'name': 'Bayar di Tempat (Cash)', 'icon': Icons.store},
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const accentGreen = Color(0xFF00C853);

    // Formatter Rupiah
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 1. HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 24,
              right: 24,
              bottom: 25,
            ),
            width: double.infinity,
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
              ],
            ),
          ),

          // 2. KONTEN SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rincian Pesanan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- KARTU RINGKASAN ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          "ID Booking",
                          "#${widget.bookingId}",
                          isBold: true,
                        ),
                        const Divider(height: 24),
                        _buildSummaryRow("Lapangan", widget.court.name),
                        const SizedBox(height: 12),
                        _buildSummaryRow("Tanggal", widget.date),
                        const SizedBox(height: 12),
                        _buildSummaryRow("Waktu", widget.time),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          "Total Tagihan",
                          currencyFormatter.format(widget.totalPrice),
                          isBold: true,
                          color: primaryBlue,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- LIST METODE PEMBAYARAN ---
                  ..._paymentMethods.map((method) {
                    bool isSelected = _selectedMethod == method['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMethod = method['id'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryBlue.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? primaryBlue
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              method['icon'],
                              color: isSelected ? primaryBlue : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                method['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? primaryBlue
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: primaryBlue,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  // --- TOMBOL BAYAR ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedMethod != -1
                            ? accentGreen
                            : Colors.grey[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: _selectedMethod != -1 ? 4 : 0,
                      ),
                      onPressed: _selectedMethod != -1
                          ? () {
                              _showSuccessDialog();
                            }
                          : null, // Disable jika belum pilih metode
                      child: const Text(
                        "Bayar Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  // Widget Helper: Baris Ringkasan
  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: fontSize,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  // Fungsi Dialog Sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Booking anda telah dikonfirmasi. Silakan cek tiket pada menu Riwayat.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Kembali ke MainNavScreen (Hapus history navigasi agar tidak bisa back ke payment)
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainNavScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text("Kembali ke Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
