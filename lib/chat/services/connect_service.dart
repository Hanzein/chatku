import 'package:user_repository/src/firebase_user_repo.dart';
import 'package:chatku/chat/services/socket_service.dart';

class ConnectionService {
  final FirebaseUserRepo _userRepo;
  final SocketService _socketService;

  ConnectionService(this._userRepo, this._socketService);

  Future<void> initializeSocketConnection() async {
    try {
      String? token = await _userRepo.getIdToken();
      if (token != null) {
        await _socketService.connect(token);
        print('Socket connection initialized');
      } else {
        print('Failed to get ID token');
      }
    } catch (e) {
      print('Error initializing socket connection: $e');
    }
  }
}
