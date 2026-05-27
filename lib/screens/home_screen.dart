import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/error_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();

    return FutureBuilder<WeatherModel>(
      future: weatherService.fetchWeatherByCity('Gurgaon'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return ErrorMessage(
            message: snapshot.error.toString().replaceAll('Exception: ', ''),
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
                'Today Weather',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Live weather data from Open-Meteo API',
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