import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
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
  final String _locationStatus = "Current location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideMitra', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F2537),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.amber),
                      const SizedBox(width: 10),
                      Text(
                        _locationStatus,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on),
                  hintText: 'Where to?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose your ride',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
