class Court {
  final String id;
  final String name;
  final String location;
  final double pricePerHour;
  final String imageUrl;
  final List<String> facilities;

  Court({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerHour,
    required this.imageUrl,
    required this.facilities,
  });

  // Factory method untuk mengubah JSON dari API menjadi Object Court
  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'].toString(), // Pastikan ID dikonversi ke String
      name: json['name'] ?? 'Tanpa Nama',
      location: json['location'] ?? '-',
      // Parse harga (pastikan tipe data sesuai dengan API)
      pricePerHour: double.tryParse(json['price'].toString()) ?? 0.0,
      // Gunakan placeholder jika gambar null
      imageUrl:
          json['image_url'] ?? 'https://placehold.co/600x400/png?text=No+Image',
      // Parsing list fasilitas (jika dikirim sebagai string dipisah koma atau array json)
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : [],
    );
  }
}
