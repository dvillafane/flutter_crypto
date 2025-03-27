import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoService {
  Future<List<Crypto>> fetchCryptos() async {
    final url = Uri.parse('https://api.coincap.io/v2/assets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cryptoList = data['data'];
      return cryptoList.map((json) => Crypto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener criptomonedas');
    }
  }
}
