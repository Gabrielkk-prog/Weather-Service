import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../widgets/weather_widgets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      final weatherData = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weatherData = weatherData;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Atual'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _loadWeather,
        tooltip: 'Atualizar clima',
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'Buscando clima e localização...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final weather = _weatherData!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Seção 1: Temperatura Principal com Animação
          MainTemperatureCard(
            cityName: weather.cityName,
            temperature: weather.temperature,
            description: weather.description,
            mainWeather: weather.mainWeather,
          ),
          const SizedBox(height: 24),

          // Seção 2: Sensação Térmica em Destaque
          WeatherCard(
            title: 'Sensação Térmica',
            value: weather.feelsLike.toStringAsFixed(1),
            unit: '°C',
            icon: Icons.thermostat,
            iconColor: Colors.orange,
          ),
          const SizedBox(height: 24),

          // Seção 3: Grid de Dados Adicionais
          Text(
            'Detalhes do Clima',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              WeatherCard(
                title: 'Umidade',
                value: weather.humidity.toString(),
                unit: '%',
                icon: Icons.water_drop,
                iconColor: Colors.blue,
              ),
              WeatherCard(
                title: 'Vento',
                value: weather.windSpeed.toStringAsFixed(1),
                unit: 'm/s',
                icon: Icons.air,
                iconColor: Colors.cyan,
              ),
              WeatherCard(
                title: 'Pressão',
                value: weather.pressure.toString(),
                unit: 'hPa',
                icon: Icons.compress,
                iconColor: Colors.indigo,
              ),
              WeatherCard(
                title: 'Visibilidade',
                value: (weather.visibility / 1000).toStringAsFixed(1),
                unit: 'km',
                icon: Icons.visibility,
                iconColor: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Seção 4: Localização
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Localização',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLocationRow(
                    Icons.location_on,
                    'Latitude',
                    weather.latitude.toStringAsFixed(5),
                  ),
                  const SizedBox(height: 12),
                  _buildLocationRow(
                    Icons.location_on,
                    'Longitude',
                    weather.longitude.toStringAsFixed(5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
