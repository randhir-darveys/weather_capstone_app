import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/error_message.dart';
import '../widgets/weather_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController cityController = TextEditingController();
  final WeatherService weatherService = WeatherService();

  Future<WeatherModel>? weatherFuture;
  List<CityLocation> citySuggestions = [];
  bool isSearchingCities = false;
  String? searchError;

  Future<void> fetchCitySuggestions(String value) async {
    if (value.trim().length < 2) {
      setState(() {
        citySuggestions = [];
        searchError = null;
      });
      return;
    }

    setState(() {
      isSearchingCities = true;
      searchError = null;
    });

    try {
      final results = await weatherService.searchCities(value);

      setState(() {
        citySuggestions = results;
      });
    } catch (e) {
      setState(() {
        searchError = e.toString().replaceAll('Exception: ', '');
        citySuggestions = [];
      });
    } finally {
      setState(() {
        isSearchingCities = false;
      });
    }
  }

  void selectCity(CityLocation city) {
    cityController.text = city.displayName;

    setState(() {
      citySuggestions = [];
      weatherFuture = weatherService.fetchWeatherByCityLocation(city);
    });
  }

  void searchWeather() {
    if (cityController.text.trim().isEmpty) return;

    setState(() {
      citySuggestions = [];
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
              labelText: 'Search city',
              hintText: 'Type Jaipur, London, New York...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: searchWeather,
              ),
            ),
            onChanged: fetchCitySuggestions,
            onSubmitted: (_) => searchWeather(),
          ),

          if (isSearchingCities) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],

          if (searchError != null) ...[
            const SizedBox(height: 12),
            Text(
              searchError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],

          if (citySuggestions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: citySuggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final city = citySuggestions[index];

                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(city.name),
                    subtitle: Text(
                      [
                        if (city.admin1.isNotEmpty) city.admin1,
                        if (city.country.isNotEmpty) city.country,
                      ].join(', '),
                    ),
                    onTap: () => selectCity(city),
                  );
                },
              ),
            ),
          ],

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
                    message: snapshot.error
                        .toString()
                        .replaceAll('Exception: ', ''),
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