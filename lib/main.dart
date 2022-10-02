import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Game of life',
      debugShowCheckedModeBanner: false,
      home: GameOfLife(
        milliseconds: 300,
        cellSize: 40,
        hideControls: false,
      ),
    );
  }
}
