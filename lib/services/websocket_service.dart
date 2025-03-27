import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  final String url;
  late final IOWebSocketChannel _channel;

  WebSocketService({
    this.url = 'wss://ws.coincap.io/prices?assets=bitcoin,ethereum,ripple,litecoin',
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
