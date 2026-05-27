class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson({
    required String cityName,
    required Map<String, dynamic> json,
  }) {
    final current = json['current'];

    return WeatherModel(
      cityName: cityName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      condition: _getConditionFromCode(current['weather_code']),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
    );
  }

  static String _getConditionFromCode(int code) {
    if (code == 0) return 'Clear Sky';
    if ([1, 2, 3].contains(code)) return 'Partly Cloudy';
    if ([45, 48].contains(code)) return 'Foggy';
    if ([51, 53, 55, 61, 63, 65].contains(code)) return 'Rainy';
    if ([71, 73, 75].contains(code)) return 'Snowy';
    if ([95, 96, 99].contains(code)) return 'Thunderstorm';

    return 'Unknown';
  }
}