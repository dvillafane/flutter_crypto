import 'package:flutter/material.dart';
import '../services/websocket_prices_service.dart';
import '../services/crypto_service.dart';
import '../models/crypto.dart';

class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  _CryptoPricesScreenState createState() => _CryptoPricesScreenState();
}

class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  final WebSocketPricesService _pricesService = WebSocketPricesService();
  final CryptoService _cryptoService = CryptoService();
  List<Crypto> _cryptos = [];

  @override
  void initState() {
    super.initState();
    _loadCryptos();
    _pricesService.pricesStream.listen((data) {
      setState(() {
        _cryptos = _cryptos.map((crypto) {
          return Crypto(
            id: crypto.id,
            name: crypto.name,
            symbol: crypto.symbol,
            price: data[crypto.id] ?? crypto.price,
            logoUrl: crypto.logoUrl,
          );
        }).toList();
      });
    });
  }

  Future<void> _loadCryptos() async {
    final cryptos = await _cryptoService.fetchCryptos();
    setState(() {
      _cryptos = cryptos;
    });
  }

  @override
  void dispose() {
    _pricesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptomonedas')),
      body: _cryptos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _cryptos.length,
              itemBuilder: (context, index) {
                final crypto = _cryptos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(crypto.logoUrl),
                    ),
                    title: Text(
                      '${crypto.name} (${crypto.symbol})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Precio: \$${crypto.price.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}
