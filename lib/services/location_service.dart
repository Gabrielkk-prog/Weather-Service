import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('O serviço de localização está desabilitado.');
    }


    // Verifica as permissões de localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }

    // Retorna a posição atual do dispositivo
    return await Geolocator.getCurrentPosition();
    } 
    }
  class WeatherService {
    final String apiKey = '';
    Future<String> getWeather(double latitude, double longitude) async {
      final String url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';
      final http.Response response = await http.get(Uri.parse(url));
      return response.body;
    }
  }
