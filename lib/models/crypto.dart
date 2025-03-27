class Crypto {
  final String name;
  final double price;

  Crypto({required this.name, required this.price});

  factory Crypto.fromJson(String key, dynamic value) {
    return Crypto(
      name: key,
      price: double.tryParse(value.toString()) ?? 0,
    );
  }
}
