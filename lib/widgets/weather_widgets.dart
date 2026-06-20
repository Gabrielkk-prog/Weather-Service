import 'package:flutter/material.dart';

/// Widget que exibe um ícone animado conforme o tipo de clima
class AnimatedWeatherIcon extends StatefulWidget {
  final String mainWeather;
  final double size;

  const AnimatedWeatherIcon({
    Key? key,
    required this.mainWeather,
    this.size = 80.0,
  }) : super(key: key);

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedWeatherIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mainWeather != widget.mainWeather) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  IconData _getWeatherIcon() {
    switch (widget.mainWeather.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return Icons.cloud_queue;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'dust':
      case 'ash':
      case 'squall':
      case 'tornado':
        return Icons.cloud_outlined;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor() {
    switch (widget.mainWeather.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return Colors.blue[700]!;
      case 'thunderstorm':
        return Colors.purple[900]!;
      case 'clouds':
        return Colors.grey[600]!;
      case 'clear':
        return Colors.amber[600]!;
      case 'snow':
        return Colors.blue[200]!;
      default:
        return Colors.grey[500]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          _getWeatherIcon(),
          size: widget.size,
          color: _getWeatherColor(),
        ),
      ),
    );
  }
}

/// Widget reutilizável para exibir uma métrica de clima
class WeatherCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color? iconColor;

  const WeatherCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.0,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para exibir a temperatura principal com animação
class MainTemperatureCard extends StatefulWidget {
  final String cityName;
  final double temperature;
  final String description;
  final String mainWeather;

  const MainTemperatureCard({
    Key? key,
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.mainWeather,
  }) : super(key: key);

  @override
  State<MainTemperatureCard> createState() => _MainTemperatureCardState();
}

class _MainTemperatureCardState extends State<MainTemperatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[400]!,
                Colors.blue[600]!,
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              Text(
                widget.cityName,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
              AnimatedWeatherIcon(
                mainWeather: widget.mainWeather,
                size: 120.0,
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.temperature.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 56.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    '°C',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.description.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
