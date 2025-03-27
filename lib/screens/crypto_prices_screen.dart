import 'package:flutter/material.dart';
import '../services/websocket_prices_service.dart';

class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  _CryptoPricesScreenState createState() => _CryptoPricesScreenState();
}

class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  final WebSocketPricesService _pricesService = WebSocketPricesService();
  final Map<String, double> _prices = {};

  @override
  void initState() {
    super.initState();
    _pricesService.pricesStream.listen((data) {
      setState(() {
        data.forEach((key, value) {
          _prices[key] = double.tryParse(value.toString()) ?? 0;
        });
      });
    });
  }

  @override
  void dispose() {
    _pricesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: _prices.entries.map((entry) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(entry.key[0].toUpperCase()),
            ),
            title: Text(
              entry.key.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Precio: \$${entry.value.toStringAsFixed(2)}'),
          ),
        );
      }).toList(),
    );
  }
}
