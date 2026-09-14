import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
      home: const MapHomeScreen(),
    );
  }
}

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition = const LatLng(28.6139, 77.2090); // Default Location
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _stopLoading();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _stopLoading();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _stopLoading();
        return;
      }

      // 5 seconds timeout added to prevent infinite loading
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _initialCameraPosition = currentLatLng;
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: currentLatLng,
              infoWindow: const InfoWindow(title: 'My Location'),
            ),
          );
          _isLoading = false;
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 15),
        );
      }
    } catch (e) {
      _stopLoading();
    }
  }

  void _stopLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideMitra Map', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F2537),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialCameraPosition,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  onMapCreated: (controller) => _mapController = controller,
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Text('Where to?', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
