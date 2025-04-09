class WeatherModel {
  final double temperature;

  WeatherModel({required this.temperature});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['current']['temp_c']?.toDouble() ?? 0.0,
    );
  }
}
