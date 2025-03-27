import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketPricesService {
  final String url;
  late final IOWebSocketChannel _channel;

  // Puedes ajustar la lista de activos o usar 'ALL' para todos.
  WebSocketPricesService({
    this.url =
        'wss://ws.coincap.io/prices?assets=bitcoin,ethereum,monero,litecoin',
  }) {
    _channel = IOWebSocketChannel.connect(url);
  }

  Stream<Map<String, dynamic>> get pricesStream {
    return _channel.stream.map((data) => jsonDecode(data) as Map<String, dynamic>);
  }

  void dispose() {
    _channel.sink.close();
  }
}
