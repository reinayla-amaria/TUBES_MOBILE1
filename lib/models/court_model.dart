class Court {
  final String id;
  final String name;
  final String location;
  final double pricePerHour;
  final String imageUrl;
  final List<String> facilities;
  final String description;

  Court({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerHour,
    required this.imageUrl,
    required this.facilities,
    required this.description,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'].toString(),
      name: json['name'] ?? "Tanpa Nama",
      location: json['location'] ?? "Lokasi tidak tersedia",
      // Perhatikan key 'price' sesuai tabel database baru
      pricePerHour: double.parse(json['price'].toString()),
      imageUrl: json['image_url'] ?? "https://via.placeholder.com/150",
      facilities: List<String>.from(json['facilities'] ?? []),
      description: json['description'] ?? "-",
    );
  }
}
