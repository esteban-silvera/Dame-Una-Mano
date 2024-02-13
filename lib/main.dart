import 'package:dame_una_mano/features/authentication/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkerScreen(),
    );
  }
}
