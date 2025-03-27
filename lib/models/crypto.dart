class Crypto {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final String logoUrl;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.logoUrl,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'].toUpperCase(),
      price: double.tryParse(json['priceUsd'] ?? '0') ?? 0,
      logoUrl: 'https://assets.coincap.io/assets/icons/${json['symbol'].toLowerCase()}@2x.png', // URL del logo
    );
  }
}
