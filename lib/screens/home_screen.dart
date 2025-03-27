import 'package:flutter/material.dart';
import 'crypto_prices_screen.dart';
import 'assets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CoinCap API 2.0 Demo'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Precios'),
              Tab(text: 'Activos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CryptoPricesScreen(),
            AssetsScreen(),
          ],
        ),
      ),
    );
  }
}
