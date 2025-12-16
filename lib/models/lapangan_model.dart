class Lapangan {
  final String id;
  final String nama;
  final String gambarUrl; // URL gambar lapangan
  final double harga;
  final double rating;
  final String lokasi;

  Lapangan({
    required this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.rating,
    required this.lokasi,
  });

  // Factory untuk mengubah JSON dari API menjadi Object Dart (Persiapan integrasi API)
  factory Lapangan.fromJson(Map<String, dynamic> json) {
    return Lapangan(
      id: json['id'],
      nama: json['nama'],
      gambarUrl: json['gambarUrl'],
      harga: json['harga'].toDouble(),
      rating: json['rating'].toDouble(),
      lokasi: json['lokasi'],
    );
  }
}
