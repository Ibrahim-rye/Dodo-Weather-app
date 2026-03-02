import 'package:dodo/models/weather_model.dart';
import 'package:dodo/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('4807c06b9d4b8713684be98a42c98fb5');
  Weather? _weather;

  // fetch weather
  void _fetchWeather() async {
    // get current city name
    String cityName = await _weatherService.getCurrentCity();
    // fetch weather data
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  // weather animation
  String _getWeatherAnimation(String mainCondition) {
    if (mainCondition.isEmpty) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // city name
          Text(
            _weather?.cityName ?? 'Loading city...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // animation
          Lottie.asset(
            _getWeatherAnimation(_weather?.mainCondition ?? ''),
            width: 300,
            height: 300,
          ),

          // tempurature
          Text(
            '${_weather?.temperature.round()}°C',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // weather condition
          Text(
            _weather?.mainCondition ?? 'Loading condition...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ));
  }
}
