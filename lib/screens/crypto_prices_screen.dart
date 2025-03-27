// Importa el paquete de Flutter para crear interfaces de usuario.
import 'package:flutter/material.dart';
// Importa el paquete para manejar temporizadores asíncronos.
import 'dart:async';

// Importa el servicio de precios a través de WebSocket.
import '../services/websocket_prices_service.dart';
// Importa el servicio para obtener la lista de criptomonedas.
import '../services/crypto_service.dart';
// Importa el modelo de datos de criptomonedas.
import '../models/crypto.dart';
// Importa el widget personalizado para mostrar cada criptomoneda.
import '../widgets/crypto_card.dart';

// Define un widget con estado (StatefulWidget) llamado CryptoPricesScreen.
class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  _CryptoPricesScreenState createState() => _CryptoPricesScreenState();
}

class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  // Instancia del servicio WebSocket para recibir precios en tiempo real.
  final WebSocketPricesService _pricesService = WebSocketPricesService();
  // Instancia del servicio para obtener la lista inicial de criptomonedas.
  final CryptoService _cryptoService = CryptoService();
  // Lista para almacenar las criptomonedas obtenidas.
  List<Crypto> _cryptos = [];
  // Mapa para almacenar los precios anteriores de cada criptomoneda.
  final Map<String, double> _previousPrices = {};
  // Mapa para almacenar el color asociado al precio de cada criptomoneda.
  final Map<String, Color> _priceColors = {};

  @override
  void initState() {
    super.initState();
    // Carga las criptomonedas al iniciar el widget.
    _loadCryptos();
    // Se suscribe al flujo de precios en tiempo real.
    _pricesService.pricesStream.listen(_updatePrices);
  }

  // Método asíncrono para cargar la lista de criptomonedas desde el servicio.
  Future<void> _loadCryptos() async {
    // Obtiene la lista de criptomonedas desde la API.
    final cryptos = await _cryptoService.fetchCryptos();
    setState(() {
      // Ordena las criptomonedas en orden descendente por precio.
      _cryptos = cryptos..sort((a, b) => b.price.compareTo(a.price));
      // Inicializa los precios anteriores y colores en negro (por defecto).
      for (var crypto in _cryptos) {
        _previousPrices[crypto.id] = crypto.price;
        _priceColors[crypto.id] = Colors.black;
      }
    });
  }

  // Actualiza los precios en tiempo real cuando se reciben nuevos datos.
  void _updatePrices(Map<String, double> data) {
    setState(() {
      // Mapea cada criptomoneda actualizando su precio y color.
      _cryptos = _cryptos.map((crypto) {
        // Obtiene el nuevo precio, si no hay datos mantiene el precio actual.
        double newPrice = data[crypto.id] ?? crypto.price;
        // Obtiene el precio anterior registrado.
        double oldPrice = _previousPrices[crypto.id] ?? crypto.price;

        // Determina el color según la variación del precio (verde, rojo o negro).
        _priceColors[crypto.id] = _determinePriceColor(newPrice, oldPrice);
        // Actualiza el precio anterior con el nuevo.
        _previousPrices[crypto.id] = newPrice;
        // Activa el parpadeo del precio cuando cambia.
        _startBlinking(crypto.id);

        // Retorna una nueva instancia de la criptomoneda actualizada.
        return Crypto(
          id: crypto.id,
          name: crypto.name,
          symbol: crypto.symbol,
          price: newPrice,
          logoUrl: crypto.logoUrl,
        );
      }).toList();
    });
  }

  // Determina el color del precio según la variación (sube, baja o se mantiene).
  Color _determinePriceColor(double newPrice, double oldPrice) {
    if (newPrice > oldPrice) return Colors.green; // Precio sube.
    if (newPrice < oldPrice) return Colors.red;   // Precio baja.
    return Colors.black;                         // Precio sin cambios.
  }

  // Inicia el parpadeo cambiando el color durante un corto periodo.
  void _startBlinking(String cryptoId) {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        // Vuelve el color al negro después del parpadeo.
        _priceColors[cryptoId] = Colors.black;
      });
    });
  }

  @override
  void dispose() {
    // Cierra la conexión WebSocket al destruir el widget.
    _pricesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título de la pantalla.
        title: const Text('Precios de Criptomonedas'),
      ),
      // Cuerpo de la pantalla que muestra la lista de criptomonedas o un indicador de carga.
      body: _cryptos.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga.
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _cryptos.length, // Número de criptomonedas.
              itemBuilder: (context, index) {
                final crypto = _cryptos[index];
                // Retorna una tarjeta con la información de cada criptomoneda.
                return CryptoCard(
                  crypto: crypto,
                  priceColor: _priceColors[crypto.id]!, // Color dinámico del precio.
                );
              },
            ),
    );
  }
}
