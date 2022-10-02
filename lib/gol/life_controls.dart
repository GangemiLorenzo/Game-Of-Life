import 'package:flutter/material.dart';
import 'package:game_of_life/gol/gol.dart';

class LifeControls extends StatefulWidget {
  const LifeControls({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final LifeController controller;

  @override
  State<LifeControls> createState() => _LifeControlsState();
}

class _LifeControlsState extends State<LifeControls> {
  late int ticks = 0;

  @override
  void initState() {
    ticks = 0;
    widget.controller.addListener(() => {
          setState(() {
            ticks++;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () => {
                  widget.controller.timer.isActive
                      ? widget.controller.interruptTimer()
                      : widget.controller.startTimer()
                },
                icon: Icon(widget.controller.timer.isActive
                    ? Icons.stop
                    : Icons.play_arrow),
                label:
                    Text(widget.controller.timer.isActive ? 'STOP' : 'START'),
              ),
              TextButton.icon(
                onPressed: () => widget.controller.clear(),
                icon: const Icon(Icons.clear),
                label: const Text('CLEAR'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
