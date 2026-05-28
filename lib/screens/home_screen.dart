import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/error_message.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();

  late Future<WeatherModel> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = weatherService.fetchWeatherByCurrentLocation();
  }

  void retryWeather() {
    setState(() {
      weatherFuture = weatherService.fetchWeatherByCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherModel>(
      future: weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return ErrorMessage(
            message: snapshot.error.toString().replaceAll('Exception: ', ''),
            onRetry: retryWeather,
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No weather data found'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Location Weather',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Live weather based on your GPS location',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              WeatherCard(weather: snapshot.data!),
            ],
          ),
        );
      },
    );
  }
}