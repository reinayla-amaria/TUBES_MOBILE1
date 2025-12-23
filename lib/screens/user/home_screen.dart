import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import Provider & Model
import '../../providers/booking_provider.dart';
import '../../models/court_model.dart';
import '../../models/booking_models.dart';

// Import Halaman Tujuan
import 'court_detail_screen.dart'; // Navigasi ke Detail dulu

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat data lapangan & jadwal user
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id'); // Ambil ID user yang login
    final name = prefs.getString('user_name');

    if (mounted) {
      setState(() => _userName = name);

      // 1. Ambil Data Lapangan
      Provider.of<BookingProvider>(context, listen: false).fetchCourts();

      // 2. Ambil Data Jadwal (Jika user sudah login)
      if (userId != null) {
        Provider.of<BookingProvider>(
          context,
          listen: false,
        ).fetchBookings(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    final List<Court> allCourts = bookingProv.courts;
    final List<Booking> myBookings = bookingProv.bookings;

    // Filter Nama Venue Unik (Agar tidak duplikat di Home)
    final Set<String> seenVenues = {};
    final List<Court> uniqueVenues = [];
    for (var court in allCourts) {
      String venueName = court.name.split(' - ')[0].trim();
      if (!seenVenues.contains(venueName)) {
        seenVenues.add(venueName);
        uniqueVenues.add(court);
      }
    }

    const primaryBlue = Color(0xFF1565C0);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo_white.png', height: 30),
                    const SizedBox(width: 8),
                    const Text(
                      "Lapangin.Aja",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "cari lapangan",
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.search, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
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

          // 2. BODY KONTEN
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPromoBanner(),
                  const SizedBox(height: 25),

                  // --- SECTION 1: LAPANGAN TERDEKAT ---
                  const Text(
                    "Lapangan Terdekat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // List Horizontal
                  SizedBox(
                    height: 270,
                    child: bookingProv.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : uniqueVenues.isEmpty
                        ? const Center(child: Text("Belum ada data lapangan."))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: uniqueVenues.length,
                            itemBuilder: (context, index) {
                              return _buildHorizontalCourtCard(
                                context,
                                uniqueVenues[index],
                                primaryBlue,
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 25),

                  // --- SECTION 2: JADWAL KAMU (DINAMIS) ---
                  const Text(
                    "Jadwal Kamu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (myBookings.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Belum ada jadwal booking.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    // Menampilkan 3 jadwal terbaru saja
                    Column(
                      children: myBookings
                          .take(3)
                          .map((booking) => _buildScheduleCard(booking))
                          .toList(),
                    ),

                  const SizedBox(height: 50), // Spasi bawah tambahan
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CARD LAPANGAN ---
  Widget _buildHorizontalCourtCard(
    BuildContext context,
    Court court,
    Color primaryColor,
  ) {
    String venueName = court.name.split(' - ')[0].trim();

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar & Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venueName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        court.location,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(court.imageUrl),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Tombol Lihat Lapangan
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  // PERBAIKAN: Navigasi ke CourtDetailScreen (Halaman Rating/Detail)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourtDetailScreen(court: court),
                    ),
                  );
                },
                child: const Text(
                  "Lihat Lapangan",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET JADWAL DINAMIS (PERBAIKAN UTAMA) ---
  Widget _buildScheduleCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Warna border beda kalau status Pending/Lunas
          color: booking.status == 'Lunas'
              ? Colors.green.shade200
              : Colors.orange.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nama Lapangan
              Expanded(
                child: Text(
                  booking.courtName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Badge Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: booking.status == 'Lunas'
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  booking.status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tanggal & Waktu
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(booking.date, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(booking.time, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET BANNER PROMO ---
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 100,
            child: Icon(
              Icons.sports_handball,
              size: 80,
              color: Colors.red[800],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Waktunya olahraga!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  "BOOKING LAPANGAN MU SEKARANG!",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {}, // Bisa diarahkan ke BookingScreen juga
                  child: const Text(
                    "Booking Sekarang!",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
