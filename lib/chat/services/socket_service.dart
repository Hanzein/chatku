import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;
  static const String _serverUrl =
      'http://10.0.2.2:3000'; // Use your server's IP or hostname

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String? token) async {
    if (_socket != null) {
      print('Socket is already initialized');
      return;
    }

    if (token == null) {
      print('Cannot connect: Token is null');
      return;
    }

    _socket = IO.io(_serverUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token}
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from server');
    });

    _socket!.onError((error) {
      print('Error: $error');
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected) {
      print('Socket is not connected. Cannot send message.');
      return;
    }
    _socket!.emit('new message', message);
  }

  void onNewMessage(Function(dynamic) callback) {
    if (!isConnected) {
      print('Socket is not connected. Cannot listen for new messages.');
      return;
    }
    _socket!.on('new message', callback);
  }

  void onInitialMessages(Function(dynamic) callback) {
    if (!isConnected) {
      print('Socket is not connected. Cannot listen for initial messages.');
      return;
    }
    _socket!.on('initial messages', callback);
  }
}
