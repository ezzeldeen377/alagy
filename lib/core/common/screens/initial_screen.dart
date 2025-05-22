import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    // TODO: Implement logout logic
    // For now, just print a message
    print('Logout pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 48),
              Column(
                children: [
                  Text(
                    'Welcome!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You are successfully logged in.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}