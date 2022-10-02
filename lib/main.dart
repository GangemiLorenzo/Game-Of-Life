import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game of life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.greenAccent,
          )),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: const GameOfLife(
                milliseconds: 200,
                cellSize: 14,
                hideControls: false,
                cellsColor: Colors.greenAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
