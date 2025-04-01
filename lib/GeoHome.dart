import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geohome extends StatefulWidget {
  const Geohome({super.key});

  @override
  State<Geohome> createState() => _GeohomeState();
}

class _GeohomeState extends State<Geohome> {
  Timer? _timer;
  String _locationMessage = "Ubicación no disponible";

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  // Función para solicitar permisos de ubicación
  Future<void> _checkAndRequestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ Permiso denegado');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ Permisos denegados permanentemente');
      return;
    }
  }

  // Función para obtener la ubicación
  Future<void> _getLocation() async {
    await _checkAndRequestPermissions();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _locationMessage =
          "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });

    print("📍 Ubicación actualizada: $_locationMessage");
  }

  // Iniciar actualizaciones cada 10 segundos
  void _startLocationUpdates() {
    _timer?.cancel(); // Cancela el temporizador si ya existe
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      _getLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el timer al cerrar la app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_locationMessage, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startLocationUpdates,
              child: const Text('Iniciar Seguimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
