import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

const apiKey = 'API_KEY'; // Replace with your OpenWeatherMap API key

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[850],
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
        ),
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  String _locationMessage = "Fetching location...";
  String _weatherDescription = "";
  double _temperature = 0.0;
  String _lottieAnimation = "assets/default.json"; // Default animation

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _locationMessage = 'Location permissions are denied.';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _fetchWeather(position.latitude, position.longitude);
  }

  bool _checkTimeOfDay() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour >= 6 && currentHour < 18) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _locationMessage = "${data['name']}, ${data['sys']['country']}";
          _temperature = data['main']['temp'];
          _weatherDescription = data['weather'][0]['description'];

          // Update Lottie animation based on weather condition
          if (data['weather'][0]['main'] == 'Clear') {
            if (_checkTimeOfDay()) {
              _lottieAnimation = "assets/clear_day.json";
            } else {
              _lottieAnimation = "assets/clear_night.json";
            }
          } else if (data['weather'][0]['main'] == 'Clouds') {
            if (_checkTimeOfDay()) {
              _lottieAnimation = "assets/cloudy_day.json";
            } else {
              _lottieAnimation = "assets/cloudy_night.json";
            }
          } else if (data['weather'][0]['main'] == 'Rain') {
            if (_checkTimeOfDay()) {
              _lottieAnimation = "assets/rainy_day.json";
            } else {
              _lottieAnimation = "assets/rainy_night.json";
            }
          } else if (data['weather'][0]['main'] == 'Snow') {
            _lottieAnimation = "assets/snow.json";
          } else if (data['weather'][0]['main'] == 'Thunderstorm') {
            _lottieAnimation = "assets/thunderstorm.json";
          } else {
            _lottieAnimation = "assets/default.json"; // Fallback animation
          }
        });
      } else {
        setState(() {
          _locationMessage = 'Failed to load weather data';
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = 'Error fetching weather data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _locationMessage,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Lottie.asset(_lottieAnimation, width: 150, height: 150),
            const SizedBox(height: 20),
            if (_weatherDescription.isNotEmpty) ...[
              Text(
                'Temperature: ${_temperature.toString()}°C',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'Condition: $_weatherDescription',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
