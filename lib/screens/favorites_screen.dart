import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  final List<String> favoriteCities = const [
    'Gurgaon',
    'Delhi',
    'Mumbai',
  ];

  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteCities.length,
      itemBuilder: (context, index) {
        final city = favoriteCities[index];

        return FutureBuilder<WeatherModel>(
          future: weatherService.fetchWeatherByCity(city),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Loading weather...'),
                ),
              );
            }

            if (snapshot.hasError) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: Text(city),
                  subtitle: Text(
                    snapshot.error.toString().replaceAll('Exception: ', ''),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return Card(
                child: ListTile(
                  title: Text(city),
                  subtitle: const Text('No data found'),
                ),
              );
            }

            final weather = snapshot.data!;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.orange,
                ),
                title: Text(weather.cityName),
                subtitle: Text(weather.condition),
                trailing: Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Favorites screen me currently static favorite cities use kiye hain.
// Har city ke liye WeatherService API call karta hai aur FutureBuilder ke through loading, error, aur success state handle karta hai.