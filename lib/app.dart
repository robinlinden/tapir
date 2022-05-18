import 'package:flutter/material.dart';

import 'home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'Tapir';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: title),
    );
  }
}
