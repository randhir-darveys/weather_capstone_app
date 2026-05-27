import 'package:flutter_test/flutter_test.dart';
import 'package:weather_capstone_app/models/weather_model.dart';

void main() {
  test('WeatherModel should parse JSON correctly', () {
    final mockJson = {
      'current': {
        'temperature_2m': 32.5,
        'relative_humidity_2m': 45,
        'weather_code': 0,
        'wind_speed_10m': 12.3,
      }
    };

    final weather = WeatherModel.fromJson(
      cityName: 'Gurgaon',
      json: mockJson,
    );

    expect(weather.cityName, 'Gurgaon');
    expect(weather.temperature, 32.5);
    expect(weather.humidity, 45);
    expect(weather.windSpeed, 12.3);
    expect(weather.condition, 'Clear Sky');
  });
}