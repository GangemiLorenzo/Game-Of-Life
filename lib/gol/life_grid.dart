import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

class LifeGrid extends StatefulWidget {
  const LifeGrid({
    required this.controller,
    required this.cellsColor,
    required this.gridColor,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final LifeController controller;
  final Color cellsColor;
  final Color gridColor;
  final Color backgroundColor;

  @override
  State<LifeGrid> createState() => _LifeGridState();
}

class _LifeGridState extends State<LifeGrid> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) =>
          _onTap(details.localPosition, widget.controller.gridSize),
      onPanUpdate: (details) =>
          _onTap(details.localPosition, widget.controller.gridSize),
      child: CustomPaint(
        painter: LifeGridPainter(
          r: widget.controller.rowsCount,
          c: widget.controller.columnsCount,
          cells: widget.controller.cells,
          cellsColor: widget.cellsColor,
          gridColor: widget.gridColor,
          backgroundColor: widget.backgroundColor,
        ),
        child: const SizedBox(
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  void _onTap(Offset tap, Size size) {
    try {
      final c = tap.dx ~/ widget.controller.cellSize;
      final r = tap.dy ~/ widget.controller.cellSize;
      setState(() {
        widget.controller.cells[r][c] = 1;
      });
    } catch (_) {}
  }
}

//------------------------------- PAINTER -------------------------------//

class LifeGridPainter extends CustomPainter {
  const LifeGridPainter({
    required this.r,
    required this.c,
    required this.cells,
    required this.cellsColor,
    required this.gridColor,
    required this.backgroundColor,
    Key? key,
  }) : super();

  final int r;
  final int c;
  final List<List<int>> cells;
  final Color cellsColor;
  final Color gridColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lh = size.height / r;
    final lw = size.width / c;

    _drawBackground(size, canvas);
    _drawGrid(size, lh, lw, canvas);
    _drawSquares(lh, lw, r, c, canvas);
  }

  void _drawBackground(Size size, Canvas canvas) {
    final height = size.height;
    final width = size.width;
    final paint = Paint()..color = backgroundColor;

    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), paint);
  }

  void _drawGrid(Size size, double lh, double lw, Canvas canvas) {
    final height = size.height;
    final width = size.width;
    const stroke = 1;
    final paint = Paint()
      ..color = gridColor
      ..strokeCap = StrokeCap.round;

    for (double h = 0; h < height + stroke; h += lh) {
      Path linePath = Path();
      linePath.addRect(Rect.fromLTRB(
          0, h.toDouble() - stroke / 2, width, h.toDouble() + stroke / 2));
      canvas.drawPath(linePath, paint);
    }

    for (double w = 0; w < width + stroke; w += lw) {
      Path linePath = Path();
      linePath.addRect(Rect.fromLTRB(
          w.toDouble() - stroke / 2, 0, w.toDouble() + stroke / 2, height));
      canvas.drawPath(linePath, paint);
    }
  }

  void _drawSquares(
    double lh,
    double lw,
    int r,
    int c,
    Canvas canvas,
  ) {
    const padding = 1;
    final paint = Paint()
      ..color = cellsColor
      ..strokeCap = StrokeCap.round;

    final secondPaint = Paint()
      ..color = cellsColor.withOpacity(0.2)
      ..strokeCap = StrokeCap.round;

    Path linePath = Path();
    Path secondPath = Path();

    for (int y = 0; y < r; y++) {
      for (int x = 0; x < c; x++) {
        final offset = Offset(x * lw + lw / 2, y * lh + lh / 2);
        if (cells[y][x] == 1) {
          secondPath.addRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                  center: offset.translate(1, 1),
                  width: lw - padding,
                  height: lh - padding,
                ),
                Radius.circular(padding.toDouble())),
          );
          linePath.addRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                  center: offset,
                  width: lw - padding,
                  height: lh - padding,
                ),
                Radius.circular(padding.toDouble())),
          );
        }
      }
    }

    canvas.drawPath(secondPath, secondPaint);
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
