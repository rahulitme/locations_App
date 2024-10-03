import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Email: ${user.email ?? 'No email available'}'),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile_with_map'),
              child: const Text('Go to Map'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/call'),
              child: const Text('Start WebRTC Call'),
            ),
          ],
        ),
      ),
    );
  }
}
