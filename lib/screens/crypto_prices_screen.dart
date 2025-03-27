import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  _CryptoPricesScreenState createState() => _CryptoPricesScreenState();
}

class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final Map<String, double> _prices = {};

  @override
  void initState() {
    super.initState();
    _webSocketService.pricesStream.listen((data) {
      setState(() {
        data.forEach((key, value) {
          _prices[key] = double.tryParse(value.toString()) ?? 0;
        });
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Precios de Criptos'),
      ),
      body: ListView(
        children: _prices.entries.map((entry) {
          return ListTile(
            title: Text(
              entry.key.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Precio: \$${entry.value.toStringAsFixed(2)}'),
          );
        }).toList(),
      ),
    );
  }
}
