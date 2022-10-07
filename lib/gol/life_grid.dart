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
        widget.controller.cells[r][c] = true;
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
  final List<List<bool>> cells;
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
    _drawConnections(lh, lw, r, c, canvas);
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

    for (double h = 0 /*lh / 2*/; h < height + stroke; h += lh) {
      Path linePath = Path();
      linePath.addRect(Rect.fromLTRB(
          0, h.toDouble() - stroke / 2, width, h.toDouble() + stroke / 2));
      canvas.drawPath(linePath, paint);
    }

    for (double w = 0 /*lw / 2*/; w < width + stroke; w += lw) {
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
    const padding = 0;
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
        if (cells[y][x]) {
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

  void _drawConnections(
    double lh,
    double lw,
    int r,
    int c,
    Canvas canvas,
  ) {
    final paint = Paint()
      ..color = cellsColor
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.first.length; j++) {
        if (!cells[i][j]) {
          continue;
        }
        final center = Offset(j * lw + lw / 2, i * lh + lh / 2);

        if (i - 1 > 0 && j - 1 > 0) {
          if (cells[i - 1][j - 1]) {
            canvas.drawPath(
              Path()
                ..moveTo(center.dx - lw / 2, center.dy - lh)
                ..quadraticBezierTo(
                  center.dx - lw / 2,
                  center.dy - lh / 2,
                  center.dx,
                  center.dy - lh / 2,
                )
                ..lineTo(center.dx - lw / 2, center.dy - lh / 2)
                ..lineTo(center.dx - lw / 2, center.dy - lh)
                ..close(),
              paint,
            );
            canvas.drawPath(
              Path()
                ..moveTo(center.dx - lw / 2, center.dy)
                ..quadraticBezierTo(
                  center.dx - lw / 2,
                  center.dy - lh / 2,
                  center.dx - lw,
                  center.dy - lh / 2,
                )
                ..lineTo(center.dx - lw / 2, center.dy - lh / 2)
                ..lineTo(center.dx - lw / 2, center.dy)
                ..close(),
              paint,
            );
          }
        }

        if (i - 1 > 0 && j + 1 < cells[i].length) {
          if (cells[i - 1][j + 1]) {
            canvas.drawPath(
              Path()
                ..moveTo(center.dx + lw / 2, center.dy - lh)
                ..quadraticBezierTo(
                  center.dx + lw / 2,
                  center.dy - lh / 2,
                  center.dx,
                  center.dy - lh / 2,
                )
                ..lineTo(center.dx + lw / 2, center.dy - lh / 2)
                ..lineTo(center.dx + lw / 2, center.dy - lh)
                ..close(),
              paint,
            );
            canvas.drawPath(
              Path()
                ..moveTo(center.dx + lw / 2, center.dy)
                ..quadraticBezierTo(
                  center.dx + lw / 2,
                  center.dy - lh / 2,
                  center.dx + lw,
                  center.dy - lh / 2,
                )
                ..lineTo(center.dx + lw / 2, center.dy - lh / 2)
                ..lineTo(center.dx + lw / 2, center.dy)
                ..close(),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
