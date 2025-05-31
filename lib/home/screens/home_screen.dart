import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/auth/bloc/auth_bloc.dart';
import 'package:mobile/auth/bloc/auth_event.dart';
import 'package:mobile/profile/bloc/profile_bloc.dart';
import 'package:mobile/profile/bloc/profile_event.dart';
import 'package:mobile/profile/repositories/user_repository.dart';
import 'package:mobile/profile/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _navigateToProfile(context),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToProfile(context),
              icon: const Icon(Icons.person),
              label: const Text('View Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create:
                  (context) =>
                      ProfileBloc(userRepository: UserRepository())
                        ..add(LoadProfile()),
              child: const ProfileScreen(),
            ),
      ),
    );
  }
}
