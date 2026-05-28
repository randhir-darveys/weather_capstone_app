import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeatherByCurrentLocation() async {
    try {
      final position = await _getCurrentPosition();

      return fetchWeatherByCoordinates(
        cityName: 'Current Location',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<WeatherModel> fetchWeatherByCity(String cityName) async {
    try {
      final cities = await searchCities(cityName);

      if (cities.isEmpty) {
        throw Exception('City not found. Please enter a valid city name.');
      }

      final city = cities.first;

      return fetchWeatherByCoordinates(
        cityName: city.displayName,
        latitude: city.latitude,
        longitude: city.longitude,
      );
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<WeatherModel> fetchWeatherByCityLocation(
      CityLocation city,
      ) async {
    return fetchWeatherByCoordinates(
      cityName: city.displayName,
      latitude: city.latitude,
      longitude: city.longitude,
    );
  }

  Future<WeatherModel> fetchWeatherByCoordinates({
    required String cityName,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$latitude'
            '&longitude=$longitude'
            '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
      );

      final response = await http.get(weatherUrl).timeout(
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
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } on FormatException {
      throw Exception('Invalid weather data received.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<CityLocation>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search'
          '?name=${Uri.encodeComponent(query.trim())}'
          '&count=8'
          '&language=en'
          '&format=json',
    );

    final response = await http.get(geoUrl).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to search cities. Please try again.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['results'] == null) {
      return [];
    }

    final List results = data['results'];

    return results.map((city) {
      return CityLocation(
        name: city['name'] ?? '',
        country: city['country'] ?? '',
        admin1: city['admin1'] ?? '',
        latitude: (city['latitude'] as num).toDouble(),
        longitude: (city['longitude'] as num).toDouble(),
      );
    }).toList();
  }

  Future<Position> _getCurrentPosition() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service is disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. Please enable it from app settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }
}

class CityLocation {
  final String name;
  final String country;
  final String admin1;
  final double latitude;
  final double longitude;

  CityLocation({
    required this.name,
    required this.country,
    required this.admin1,
    required this.latitude,
    required this.longitude,
  });

  String get displayName {
    final parts = [
      name,
      if (admin1.isNotEmpty) admin1,
      if (country.isNotEmpty) country,
    ];

    return parts.join(', ');
  }
}