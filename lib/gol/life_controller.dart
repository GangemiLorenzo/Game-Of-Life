import 'dart:async';

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

    cells = [
      for (int i = 0; i < rowsCount; i++)
        [for (int j = 0; j < columnsCount; j++) false]
    ];

    startTimer();
  }

  final double cellSize;
  final int milliseconds;
  final Size gridSize;
  final Size controlsSize;

  late List<List<bool>> cells;
  late Timer timer;

  late int columnsCount;
  late int rowsCount;

  int _listenersCount = 0;
  List<VoidCallback?> _listeners = List<VoidCallback?>.filled(0, null);

  void clear() {
    interruptTimer();
    _clearCells();
    callListeners();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: milliseconds), (t) {
      _compute();
      callListeners();
    });
    callListeners();
  }

  void interruptTimer() {
    timer.cancel();
  }

  void dispose() {
    timer.cancel();
  }

  void _compute() {
    List<List<bool>> nextGeneration = [
      for (int i = 0; i < cells.length; i++)
        [for (int j = 0; j < cells.first.length; j++) false]
    ];

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.first.length; j++) {
        int n = 0;
        if (i - 1 > 0) {
          if (j - 1 > 0) {
            n += cells[i - 1][j - 1] ? 1 : 0;
          }
          n += cells[i - 1][j] ? 1 : 0;
          if (j + 1 < cells[i].length) {
            n += cells[i - 1][j + 1] ? 1 : 0;
          }
        }
        if (i + 1 < cells.length) {
          if (j - 1 > 0) {
            n += cells[i + 1][j - 1] ? 1 : 0;
          }
          n += cells[i + 1][j] ? 1 : 0;
          if (j + 1 < cells[i].length) {
            n += cells[i + 1][j + 1] ? 1 : 0;
          }
        }

        if (j - 1 > 0) {
          n += cells[i][j - 1] ? 1 : 0;
        }
        if (j + 1 < cells[i].length) {
          n += cells[i][j + 1] ? 1 : 0;
        }

        if (cells[i][j] && (n == 2 || n == 3)) {
          nextGeneration[i][j] = cells[i][j];
        } else if (cells[i][j]) {
          nextGeneration[i][j] = false;
        }
        if (!cells[i][j] && n == 3) {
          nextGeneration[i][j] = !cells[i][j];
        }
      }
    }

    cells = nextGeneration;
  }

  _clearCells() {
    cells = [
      for (int i = 0; i < cells.length; i++)
        [for (int j = 0; j < cells.first.length; j++) false]
    ];
  }

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
}
