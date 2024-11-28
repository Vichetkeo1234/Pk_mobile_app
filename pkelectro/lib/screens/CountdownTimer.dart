import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Duration duration = Duration(hours: 48, minutes: 0, seconds: 0);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          duration -= Duration(seconds: 1);
        });
      }
    });
  }

  String formatTime(int time) => time.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = formatTime(duration.inHours);
    final minutes = formatTime(duration.inMinutes.remainder(60));
    final seconds = formatTime(duration.inSeconds.remainder(60));

    return Row(
      children: [
        _buildTimeBox(hours),
        _buildSeparator(),
        _buildTimeBox(minutes),
        _buildSeparator(),
        _buildTimeBox(seconds),
      ],
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(":", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
