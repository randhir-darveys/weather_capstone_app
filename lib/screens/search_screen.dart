import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/error_message.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController cityController = TextEditingController();
  final WeatherService weatherService = WeatherService();

  Future<WeatherModel>? weatherFuture;

  void searchWeather() {
    if (cityController.text.trim().isEmpty) return;

    setState(() {
      weatherFuture = weatherService.fetchWeatherByCity(
        cityController.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: 'Enter city name',
              hintText: 'Try Delhi, Mumbai, Gurgaon',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: searchWeather,
              ),
            ),
            onSubmitted: (_) => searchWeather(),
          ),
          const SizedBox(height: 20),

          if (weatherFuture == null)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Search weather by city name',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            FutureBuilder<WeatherModel>(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return ErrorMessage(
                    message: snapshot.error.toString().replaceAll('Exception: ', ''),
                    onRetry: searchWeather,
                  );
                }

                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text('No weather data found'),
                  );
                }

                return WeatherCard(weather: snapshot.data!);
              },
            ),
        ],
      ),
    );
  }
}