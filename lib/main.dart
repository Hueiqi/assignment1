import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const PetFinder());
}

class PetFinder extends StatelessWidget {
  const PetFinder({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'student event poster',
      home: const InputScreen(title: 'STUDENT EVENT POSTER'),
    );
  }
}
