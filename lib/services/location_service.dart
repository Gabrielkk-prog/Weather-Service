import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<Position> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('O serviço de localização está desabilitado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }

    return await Geolocator.getCurrentPosition();
  }
}

class WeatherData {
  final String cityName;
  final String description;
  final double temperature;
  final double latitude;
  final double longitude;

  WeatherData({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherService {
  final String apiKey = 'a851844083ebd257332cb87c3e75e7a2';

  Future<WeatherData> getWeather(double latitude, double longitude) async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar o clima: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
    final String cityName = json['name']?.toString() ?? 'Localização desconhecida';
    final String description = (json['weather'] as List<dynamic>).isNotEmpty
        ? json['weather'][0]['description'].toString()
        : 'Sem descrição';
    final double temperature = (json['main']?['temp'] as num?)?.toDouble() ?? 0.0;

    return WeatherData(
      cityName: cityName,
      description: description,
      temperature: temperature,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
