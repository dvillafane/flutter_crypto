import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketPricesService {
  final _channel = IOWebSocketChannel.connect('wss://ws.coincap.io/prices?assets=bitcoin,ethereum,monero,litecoin');

  Stream<Map<String, double>> get pricesStream async* {
    await for (var message in _channel.stream) {
      final Map<String, dynamic> data = json.decode(message);
      final Map<String, double> parsedData = {};
      data.forEach((key, value) {
        parsedData[key] = double.tryParse(value.toString()) ?? 0;
      });
      yield parsedData;
    }
  }

  void dispose() {
    _channel.sink.close();
  }
}
