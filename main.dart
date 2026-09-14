import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  // 1. Critical for release mode native binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Prevent instant app termination on unexpected UI/Plugin errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const RideMitraApp());
}

class RideMitraApp extends StatelessWidget {
  const RideMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RideMitra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RideHomeScreen(),
    );
  }
}

class RideHomeScreen extends StatefulWidget {
  const RideHomeScreen({super.key});

  @override
  State<RideHomeScreen> createState() => _RideHomeScreenState();
}

class _RideHomeScreenState extends State<RideHomeScreen> {
  String _locationStatus = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() => _locationStatus = "Location services disabled");
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() => _locationStatus = "Permission denied");
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() => _locationStatus = "Permission permanently denied");
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );

      if (mounted) {
        setState(() {
          _locationStatus = "Lat: ${position.latitude}, Long: ${position.longitude}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationStatus = "Location Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideMitra'),
        backgroundColor: const Color(0xFF0F2537),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _locationStatus,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose your ride',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRideOption('Bike', 'Fast & Affordable', '₹45', '2 min', Icons.directions_bike),
              _buildRideOption('Auto', 'Comfortable & Quick', '₹78', '4 min', Icons.electric_rickshaw),
              _buildRideOption('Cab', 'AC Car • More Space', '₹132', '6 min', Icons.directions_car),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideOption(String title, String subtitle, String price, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: ColorAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
