import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/auth/bloc/auth_bloc.dart';
import 'package:mobile/auth/bloc/auth_event.dart';
import 'package:mobile/auth/bloc/auth_state.dart';
import 'package:mobile/auth/repositories/auth_repository.dart';
import 'package:mobile/auth/screens/login_screen.dart';
import 'package:mobile/home/screens/home_screen.dart';
import 'package:mobile/features/shopping_cart/bloc/cart_bloc.dart';

void main() {
  final authRepository = AuthRepository();
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'Paint Color Swap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial || state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is AuthAuthenticated) {
              return HomeScreen(username: state.username);
            }
            if (state is AuthUnauthenticated || state is AuthFailure) {
              return LoginScreen();
            }
            return const Scaffold(body: Center(child: Text('Unknown State')));
          },
        ),
      ),
    );
  }
}
