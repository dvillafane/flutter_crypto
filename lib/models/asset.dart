// lib/models/asset.dart
class Asset {
  final String id;
  final int rank;
  final String symbol;
  final String name;

  Asset({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      rank: int.tryParse(json['rank'] ?? '') ?? 0,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }
}
