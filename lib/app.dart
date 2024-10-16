import 'package:chatku/app_view.dart';
import 'package:chatku/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:chatku/chat/services/socket_service.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final SocketService socketService;

  const MyApp(this.userRepository, this.socketService, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<SocketService>.value(value: socketService),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          userRepository: userRepository,
          socketService: socketService,
        ),
        child: const MyAppView(),
      ),
    );
  }
}
