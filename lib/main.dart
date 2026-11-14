import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_list_test/features/user/presentation/user_page.dart';

void main() {
  // ProviderScope holds the state of every provider in the app.
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Users', home: UserPage());
  }
}
