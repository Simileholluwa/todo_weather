import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/exceptions/app_exception.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final String apiKey;

  WeatherApiService(this.apiKey);

  Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse(
      '${AppConstants.weatherApiBaseUrl}?key=$apiKey&q=$city&aqi=no',
    );

    final response = await http.get(url).timeout(AppConstants.requestTimeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw ApiException("Failed to load weather data");
    }
  }
}
