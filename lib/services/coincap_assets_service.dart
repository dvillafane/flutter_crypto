// lib/services/coincap_assets_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asset.dart';

class CoinCapAssetsService {
  final String _baseUrl = 'https://api.coincap.io/v2/assets';

  Future<List<Asset>> fetchAssets({int limit = 100}) async {
    final url = Uri.parse('$_baseUrl?limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List assetsData = jsonBody['data'];
      return assetsData.map((asset) => Asset.fromJson(asset)).toList();
    } else {
      throw Exception('Error al cargar los activos');
    }
  }
}
