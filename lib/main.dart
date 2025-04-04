import 'package:flutter/material.dart';
import 'GeoHome.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoHome',
      theme: ThemeData.dark(useMaterial3: true),
      
      home: const Geohome(),
    );
  }
}