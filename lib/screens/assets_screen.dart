// lib/screens/assets_screen.dart
import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/coincap_assets_service.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final CoinCapAssetsService _assetsService = CoinCapAssetsService();
  late Future<List<Asset>> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = _assetsService.fetchAssets();
  }

  Future<void> _refreshAssets() async {
    setState(() {
      _assetsFuture = _assetsService.fetchAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Asset>>(
      future: _assetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final assets = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshAssets,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    leading: Text(
                      asset.rank.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(asset.name),
                    subtitle: Text(asset.symbol),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
