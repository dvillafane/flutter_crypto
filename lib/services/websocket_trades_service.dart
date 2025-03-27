import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketTradesService {
  final String exchange;
  late final IOWebSocketChannel _channel;

  WebSocketTradesService({required this.exchange}) {
    _channel = IOWebSocketChannel.connect('wss://ws.coincap.io/trades/$exchange');
  }

  Stream<Map<String, dynamic>> get tradesStream {
    return _channel.stream.map((data) => jsonDecode(data) as Map<String, dynamic>);
  }

  void dispose() {
    _channel.sink.close();
  }
}
