// Importación de paquetes necesarios de Flutter y otros servicios y modelos.
import 'package:flutter/material.dart';
import '../services/websocket_prices_service.dart'; // Servicio que maneja la conexión WebSocket para precios.
import '../services/crypto_service.dart'; // Servicio que obtiene la lista de criptomonedas.
import '../models/crypto.dart'; // Modelo que representa una criptomoneda.

/// Widget con estado que muestra la lista de precios de criptomonedas.
class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  _CryptoPricesScreenState createState() => _CryptoPricesScreenState();
}

/// Estado del widget CryptoPricesScreen.
class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  // Instancia del servicio WebSocket que se encargará de recibir actualizaciones de precios.
  final WebSocketPricesService _pricesService = WebSocketPricesService();
  // Instancia del servicio que obtiene la lista de criptomonedas.
  final CryptoService _cryptoService = CryptoService();
  // Lista principal de criptomonedas.
  List<Crypto> _cryptos = [];
  // Lista de criptomonedas filtradas según la búsqueda.
  List<Crypto> _filteredCryptos = [];
  // Variable para almacenar el texto de búsqueda.
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Cargar inicialmente la lista de criptomonedas.
    _loadCryptos();

    // Escuchar las actualizaciones de precios que llegan desde el servicio WebSocket.
    _pricesService.pricesStream.listen((data) {
      setState(() {
        // Actualizar la lista de criptomonedas con los nuevos precios recibidos.
        _cryptos =
            _cryptos.map((crypto) {
              return Crypto(
                id: crypto.id,
                name: crypto.name,
                symbol: crypto.symbol,
                // Se actualiza el precio si hay un precio nuevo disponible en el 'data',
                // de lo contrario se mantiene el precio anterior.
                price: data[crypto.id] ?? crypto.price,
                logoUrl: crypto.logoUrl,
              );
            }).toList();

        // Ordenar la lista de criptomonedas de mayor a menor precio.
        _cryptos.sort((a, b) => b.price.compareTo(a.price));

        // Actualizar la lista filtrada según el criterio de búsqueda.
        _filterCryptos();
      });
    });
  }

  /// Método asíncrono para cargar la lista de criptomonedas usando el servicio.
  Future<void> _loadCryptos() async {
    final cryptos = await _cryptoService.fetchCryptos();
    setState(() {
      _cryptos = cryptos;
      // Ordenar la lista de criptomonedas de mayor a menor precio.
      _cryptos.sort((a, b) => b.price.compareTo(a.price));
      // Inicialmente, la lista filtrada es igual a la lista completa.
      _filteredCryptos = List.from(_cryptos);
    });
  }

  /// Método para filtrar las criptomonedas según la búsqueda ingresada por el usuario.
  void _filterCryptos() {
    setState(() {
      _filteredCryptos =
          _cryptos.where((crypto) {
            // Se filtra si el nombre o el símbolo contienen el texto de búsqueda (ignorando mayúsculas/minúsculas).
            return crypto.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                crypto.symbol.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    });
  }

  @override
  void dispose() {
    // Liberar recursos del servicio WebSocket al salir del widget.
    _pricesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de aplicación con título.
      appBar: AppBar(title: const Text('Precios de Criptomonedas')),
      body: Column(
        children: [
          // Campo de búsqueda para filtrar criptomonedas.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar criptomoneda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              // Cada vez que se cambia el texto, se actualiza la búsqueda y se filtra la lista.
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterCryptos();
                });
              },
            ),
          ),
          // Área expandible para mostrar la lista de criptomonedas.
          Expanded(
            child:
                _filteredCryptos.isEmpty
                    // Si la lista filtrada está vacía, se muestra un indicador de carga.
                    ? const Center(child: CircularProgressIndicator())
                    // De lo contrario, se muestra la lista de criptomonedas.
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _filteredCryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = _filteredCryptos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: ListTile(
                            // Imagen circular que muestra el logo de la criptomoneda.
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(crypto.logoUrl),
                            ),
                            // Título con el nombre y símbolo de la criptomoneda.
                            title: Text(
                              '${crypto.name} (${crypto.symbol})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Subtítulo que muestra el precio formateado.
                            subtitle: Text(
                              'Precio: \$${crypto.price.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
