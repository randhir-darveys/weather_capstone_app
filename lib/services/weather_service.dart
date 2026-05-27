import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeatherByCity(String cityName) async {
    try {
      final city = _getCityCoordinates(cityName);

      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=${city['latitude']}'
            '&longitude=${city['longitude']}'
            '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return WeatherModel.fromJson(
          cityName: cityName,
          json: data,
        );
      } else {
        throw Exception('Server error. Please try again later.');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on FormatException {
      throw Exception('Invalid weather data received.');
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Map<String, double> _getCityCoordinates(String cityName) {
    final cities = {
      'gurgaon': {'latitude': 28.4595, 'longitude': 77.0266},
      'delhi': {'latitude': 28.6139, 'longitude': 77.2090},
      'mumbai': {'latitude': 19.0760, 'longitude': 72.8777},
      'bangalore': {'latitude': 12.9716, 'longitude': 77.5946},
      'kolkata': {'latitude': 22.5726, 'longitude': 88.3639},
      'chennai': {'latitude': 13.0827, 'longitude': 80.2707},
    };

    final key = cityName.toLowerCase().trim();

    if (!cities.containsKey(key)) {
      throw Exception('City not found. Try Gurgaon, Delhi, Mumbai, Bangalore, Kolkata or Chennai.');
    }

    return cities[key]!;
  }
}