import 'package:chatku/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:chatku/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
import 'screens/home/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Colors.black,
              primary: Color.fromRGBO(29, 9, 255, 0.373),
              onPrimary: Colors.black,
              secondary: Color.fromRGBO(42, 43, 130, 1),
              onSecondary: Colors.white,
              tertiary: Color.fromRGBO(255, 0, 0, 1),
              error: Colors.red,
              outline: Color(0xFF424242)),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => SignInBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository),
              child: HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        }));
  }
}
