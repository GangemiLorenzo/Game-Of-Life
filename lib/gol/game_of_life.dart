import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

class GameOfLife extends StatefulWidget {
  const GameOfLife({
    required this.milliseconds,
    required this.cellSize,
    this.controlsHeight = 100,
    this.hideControls = false,
    this.cellsColor = const Color.fromARGB(255, 55, 242, 158),
    this.backgroundColor = const Color.fromARGB(221, 0, 0, 0),
    this.gridColor = const Color.fromARGB(31, 255, 255, 255),
    Key? key,
  }) : super(key: key);

  final int milliseconds;
  final double cellSize;
  final double controlsHeight;
  final bool hideControls;
  final Color cellsColor;
  final Color gridColor;
  final Color backgroundColor;

  @override
  State<GameOfLife> createState() => _GameOfLifeState();
}

class _GameOfLifeState extends State<GameOfLife> {
  LifeController? lifeController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size is Size) {
        setState(() {
          lifeController = LifeController(
            milliseconds: widget.milliseconds,
            cellSize: widget.cellSize,
            gridSize: Size(
              context.size!.width,
              context.size!.height -
                  (!widget.hideControls ? widget.controlsHeight : 0),
            ),
            controlsSize: Size(
              context.size!.width,
              widget.controlsHeight,
            ),
          );
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    lifeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: lifeController != null
              ? Column(
                  children: [
                    if (!widget.hideControls)
                      SizedBox(
                        height: lifeController!.controlsSize.height,
                        child: LifeControls(
                          controller: lifeController!,
                        ),
                      ),
                    Expanded(
                      child: LifeGrid(
                        controller: lifeController!,
                        cellsColor: widget.cellsColor,
                        gridColor: widget.gridColor,
                        backgroundColor: widget.backgroundColor,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
        ),
      ],
    );
  }
}
