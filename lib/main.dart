import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(), // Envolve o app no simulador
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // Garante que o tamanho simule o celular
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
          );
  }
}
