import 'package:flutter/material.dart';

class WeatherBadge extends StatelessWidget {
  final double temperature;

  const WeatherBadge({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$temperature°C'),
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}
