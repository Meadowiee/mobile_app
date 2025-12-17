import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../utils/session_manager.dart';

class ChatSocketService {
  static const String socketUrl = "http://18.143.199.169:3000";
  static IO.Socket? _socket;

  static Future<void> connect({
    required String roomId,
    required Function(dynamic) onReceive,
  }) async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;

    final token = await SessionManager().getToken();

    if (token == null) {
      print("❌ SOCKET ERROR: Token is null");
      return;
    }

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('join_room', roomId);
      print("✅ SOCKET CONNECTED TO ROOM: $roomId");
    });

    _socket!.off('receive_message');
    _socket!.on('receive_message', onReceive);

    _socket!.onDisconnect((_) {
      print("🔌 SOCKET DISCONNECTED");
    });
  }

  static void sendMessage({
    required String roomId,
    required String message,
  }) {
    if (_socket == null) return;

    _socket!.emit('send_message', {
      'roomId': roomId,
      'message': message,
    });
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
