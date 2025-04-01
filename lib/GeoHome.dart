import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Geohome extends StatefulWidget {
  const Geohome({super.key});

  @override
  State<Geohome> createState() => _GeohomeState();
}

class _GeohomeState extends State<Geohome> {
  final Location _location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  String _locationMessage = "Ubicación no disponible";

  @override
  void initState() {
    super.initState();
    _requestPermissionAndStart();
  }

  // Solicitar permisos de ubicación y activar el modo background
  Future<void> _requestPermissionAndStart() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        print("❌ Servicio de ubicación deshabilitado");
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("❌ Permiso denegado");
        return;
      }
    }

    _location.enableBackgroundMode(enable: true);
    _startLocationUpdates();
  }

  // Obtener la ubicación en tiempo real
  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        _currentLocation = newLocation;
        _locationMessage = "Lat: ${newLocation.latitude}, Lng: ${newLocation.longitude}";
      });
      print("📍 Ubicación actualizada: $_locationMessage");
    });
  }

  // Detener la actualización de ubicación
  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    setState(() {
      _locationMessage = "Seguimiento detenido";
    });
    print("⛔ Seguimiento detenido");
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancelar la suscripción al cerrar la app
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
            Text(_locationMessage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startLocationUpdates,
              child: const Text('Iniciar Seguimiento'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _stopLocationUpdates,
              child: const Text('Detener Seguimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
