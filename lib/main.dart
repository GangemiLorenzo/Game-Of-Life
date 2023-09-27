import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late double cellSize;
  late int milliseconds;

  @override
  void initState() {
    cellSize = 14;
    milliseconds = 200;
    super.initState();
  }

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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Slider(
                            onChanged: (value) => setState(() {
                              cellSize = value;
                            }),
                            divisions: 90,
                            value: cellSize.toDouble(),
                            max: 100,
                            min: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Slider(
                            onChanged: (value) => setState(() {
                              milliseconds = value.ceil();
                            }),
                            divisions: 99,
                            value: milliseconds.toDouble(),
                            max: 1000,
                            min: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: GameOfLife(
                      milliseconds: milliseconds,
                      cellSize: cellSize,
                      hideControls: false,
                      cellsColor: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
