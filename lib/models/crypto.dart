// Definición de la clase Crypto, que representa una criptomoneda.
class Crypto {
  // Propiedades de la clase:
  final String id; // Identificador único de la criptomoneda.
  final String name; // Nombre de la criptomoneda.
  final String symbol; // Símbolo de la criptomoneda (por ejemplo, BTC, ETH).
  final double price; // Precio actual de la criptomoneda.
  final String logoUrl; // URL del logo de la criptomoneda.

  // Constructor de la clase que recibe todos los parámetros requeridos.
  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.logoUrl,
  });

  // Método de fábrica que crea una instancia de Crypto a partir de un Map (JSON).
  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'], // Asigna el valor del campo 'id' del JSON.
      name: json['name'], // Asigna el valor del campo 'name' del JSON.
      // Convierte el símbolo a mayúsculas.
      symbol: json['symbol'].toUpperCase(),
      // Intenta convertir el precio obtenido en el campo 'priceUsd' a un valor double.
      // Si la conversión falla, se asigna 0.
      price: double.tryParse(json['priceUsd'] ?? '0') ?? 0,
      // Construye la URL del logo utilizando el símbolo en minúsculas.
      logoUrl:
          'https://assets.coincap.io/assets/icons/${json['symbol'].toLowerCase()}@2x.png',
    );
  }
}
