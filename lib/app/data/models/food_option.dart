class FoodOption {
  final String id;           // ID unik (misal: 'soto', 'mie') untuk database
  final String name;         // Nama Makanan
  final double rating;       // Bintang (4.8)
  final int distanceMinutes; // Jarak waktu (5 min)
  final double price;        // Harga (35000)

  // Constructor
  FoodOption({
    required this.id,
    required this.name,
    required this.rating,
    required this.distanceMinutes,
    required this.price,
  });
}