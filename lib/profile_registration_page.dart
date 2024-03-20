import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileRegistrationPage extends HookConsumerWidget {
  const ProfileRegistrationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Registration'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Text('Name'),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
