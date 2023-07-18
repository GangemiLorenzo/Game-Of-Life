import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class LifeController {
  LifeController({
    required this.milliseconds,
    required this.cellSize,
    required this.gridSize,
    required this.controlsSize,
  }) {
    rowsCount = gridSize.height ~/ cellSize;
    columnsCount = gridSize.width ~/ cellSize;

    cells = emptyCells();
    backBuffer = emptyCells();
    startTimer();
  }

  LifeController update({
    int? milliseconds,
    double? cellSize,
    Size? gridSize,
    Size? controlsSize,
  }) {
    return LifeController(
      milliseconds: milliseconds ?? this.milliseconds,
      cellSize: cellSize ?? this.cellSize,
      gridSize: gridSize ?? this.gridSize,
      controlsSize: controlsSize ?? this.controlsSize,
    )..copyCells(cells);
  }

  final double cellSize;
  final int milliseconds;
  final Size gridSize;
  final Size controlsSize;

  late List<List<int>> cells;
  late List<List<int>> backBuffer;

  late Timer timer;

  late int columnsCount;
  late int rowsCount;

  int _listenersCount = 0;
  List<VoidCallback?> _listeners = List<VoidCallback?>.filled(0, null);

  void clear() {
    interruptTimer();
    cells = emptyCells();
    callListeners();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: milliseconds), (t) {
      compute();
      callListeners();
    });
    callListeners();
  }

  void interruptTimer() {
    timer.cancel();
    callListeners();
  }

  void dispose() {
    timer.cancel();
  }

  void compute() {
    cells.asMap().entries.forEach((r) {
      r.value.asMap().entries.forEach((c) {
        int n = 0;
        int i = r.key;
        int j = c.key;
        backBuffer[i][j] = 0;

        if (i - 1 > 0) {
          if (j - 1 > 0) {
            n += cells[i - 1][j - 1];
          }
          n += cells[i - 1][j];
          if (j + 1 < cells[i].length) {
            n += cells[i - 1][j + 1];
          }
        }
        if (i + 1 < cells.length) {
          if (j - 1 > 0) {
            n += cells[i + 1][j - 1];
          }
          n += cells[i + 1][j];
          if (j + 1 < cells[i].length) {
            n += cells[i + 1][j + 1];
          }
        }

        if (j - 1 > 0) {
          n += cells[i][j - 1];
        }
        if (j + 1 < cells[i].length) {
          n += cells[i][j + 1];
        }

        if (cells[i][j] == 1 && (n == 2 || n == 3)) {
          backBuffer[i][j] = cells[i][j];
        } else if (cells[i][j] == 1) {
          backBuffer[i][j] = 0;
        }
        if (cells[i][j] == 0 && n == 3) {
          backBuffer[i][j] = 1 - cells[i][j];
        }
      });
    });

    final supp = cells;
    cells = backBuffer;
    backBuffer = supp;
  }

  List<List<int>> emptyCells() => List<List<int>>.generate(
        rowsCount,
        (_) => [
          ...List<int>.filled(columnsCount, 0),
        ],
      );

  void addListener(VoidCallback listener) {
    if (_listenersCount == _listeners.length) {
      if (_listenersCount == 0) {
        _listeners = List<VoidCallback?>.filled(1, null);
      } else {
        final List<VoidCallback?> newListeners =
            List<VoidCallback?>.filled(_listeners.length * 2, null);
        for (int i = 0; i < _listenersCount; i++) {
          newListeners[i] = _listeners[i];
        }
        _listeners = newListeners;
      }
    }
    _listeners[_listenersCount++] = listener;
  }

  void callListeners() {
    for (var l in _listeners) {
      l?.call();
    }
  }

  void copyCells(List<List<int>> oldCells) {
    final oldRowCount = oldCells.length;
    final oldColumnCount = oldCells[0].length;

    final newRowCount = cells.length;
    final newColumnCount = cells[0].length;

    // Calculate starting indices for central alignment
    final rowOffset = max(0, (newRowCount - oldRowCount) ~/ 2);
    final columnOffset = max(0, (newColumnCount - oldColumnCount) ~/ 2);

    for (var i = 0; i < oldRowCount; i++) {
      for (var j = 0; j < oldColumnCount; j++) {
        // Make sure indices are within the bounds of the newCells array
        final newRow = i + rowOffset;
        final newColumn = j + columnOffset;

        if (newRow < newRowCount && newColumn < newColumnCount) {
          cells[newRow][newColumn] = oldCells[i][j];
        }
      }
    }
  }
}
