import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const RideMitraApp());

class RideMitraApp extends StatelessWidget {
  const RideMitraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RideMitra',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC400))),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _map;
  LatLng _center = const LatLng(25.5941, 85.1376); // Patna fallback
  LatLng? _myLocation;
  String selected = 'Bike';
  final pickup = TextEditingController(text: 'Current location');
  final drop = TextEditingController();

  final rides = const {
    'Bike': {'fare': '₹45', 'time': '2 min', 'sub': 'Fast & Affordable'},
    'Auto': {'fare': '₹78', 'time': '4 min', 'sub': 'Comfortable & Quick'},
    'Cab': {'fare': '₹132', 'time': '6 min', 'sub': 'AC Car • More Space'},
  };

  @override
  void initState() { super.initState(); _locate(); }
  @override
  void dispose() { pickup.dispose(); drop.dispose(); super.dispose(); }

  Future<void> _locate() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;
    final p = await Geolocator.getCurrentPosition();
    final point = LatLng(p.latitude, p.longitude);
    if (!mounted) return;
    setState(() { _myLocation = point; _center = point; pickup.text = 'My current location'; });
    await _map?.animateCamera(CameraUpdate.newLatLngZoom(point, 15));
  }

  void bookRide() {
    if (drop.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your destination.')));
      return;
    }
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.search, size: 56), const SizedBox(height: 12),
        Text('Finding a ${selected.toLowerCase()} driver…', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), Text('${pickup.text} → ${drop.text}'), const SizedBox(height: 20),
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel Search')),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: const Color(0xFF06243D), foregroundColor: Colors.white, title: const Text.rich(TextSpan(children: [
      TextSpan(text: 'Ride', style: TextStyle(fontWeight: FontWeight.w800)),
      TextSpan(text: 'Mitra', style: TextStyle(color: Color(0xFFFFC400), fontWeight: FontWeight.w800)),
    ])), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))]),
    body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 230, child: ClipRRect(borderRadius: BorderRadius.circular(22), child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 12),
        myLocationEnabled: _myLocation != null,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (c) => _map = c,
        markers: {if (_myLocation != null) Marker(markerId: const MarkerId('me'), position: _myLocation!, infoWindow: const InfoWindow(title: 'You are here'))},
      ))),
      const SizedBox(height: 8), Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(onPressed: _locate, icon: const Icon(Icons.my_location), label: const Text('Use my location'))),
      _field(Icons.my_location, 'Pickup location', pickup), const SizedBox(height: 10), _field(Icons.location_on, 'Where to?', drop),
      const SizedBox(height: 18), const Text('Choose your ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
      ...rides.entries.map((e) => _rideCard(e.key, e.value)), const SizedBox(height: 8),
      const Card(child: ListTile(leading: Icon(Icons.payments_outlined), title: Text('Payment'), subtitle: Text('Cash / UPI'), trailing: Icon(Icons.chevron_right))),
      const SizedBox(height: 12), SizedBox(width: double.infinity, height: 54, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFC400), foregroundColor: Colors.black), onPressed: bookRide, child: const Text('Book Ride', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))))
    ])),
  );

  Widget _field(IconData icon, String label, TextEditingController c) => TextField(controller: c, decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)));

  Widget _rideCard(String name, Map<String, String> data) {
    final active = selected == name;
    final icon = name == 'Bike' ? Icons.two_wheeler : name == 'Auto' ? Icons.electric_rickshaw : Icons.directions_car;
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: active ? const Color(0xFFFFC400) : Colors.transparent, width: 2)), child: ListTile(onTap: () => setState(() => selected = name), leading: CircleAvatar(child: Icon(icon)), title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(data['sub']!), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(data['fare']!, style: const TextStyle(fontWeight: FontWeight.bold)), Text(data['time']!, style: const TextStyle(fontSize: 12))])));
  }
}
