
  final List<Map<String, String>> popularPlaces = [
    {"name": "Railway Station", "distance": "3.5 km", "price": "₹45"},
    {"name": "Main Market / City Mall", "distance": "5.2 km", "price": "₹65"},
    {"name": "Airport", "distance": "12.0 km", "price": "₹180"},
    {"name": "Bus Stand", "distance": "2.1 km", "price": "₹35"},
  ];

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Where to?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.amber),
                  hintText: 'Enter destination...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Popular Destinations', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              ...popularPlaces.map((place) => ListTile(
                leading: const Icon(Icons.location_on, color: Colors.amber),
                title: Text(place['name']!),
                subtitle: Text(place['distance']!),
                trailing: Text(place['price']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() {
                    selectedDestination = place['name']!;
                    ridePrice = place['price']!;
                  });
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _startBookingProcess() {
    setState(() => isBooking = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => isBooking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver Found! Ramesh Kumar is on the way (Hero Splendor - BR01 AB 1234)'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideMitra', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F2537),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map Mock Area
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isBooking ? Icons.local_taxi : Icons.map_rounded,
                            size: 64,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isBooking ? "Finding Nearest Drivers..." : "Live Map Area",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (isBooking) const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: CircularProgressIndicator(color: Colors.amber),
                          )
                        ],
                      ),
                    ),
                    // Where To Search Bar Trigger
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: _showSearchBottomSheet,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.amber),
                                const SizedBox(width: 10),
                                Text(
                                  selectedDestination,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: selectedDestination == "Select Destination" ? FontWeight.normal : FontWeight.bold,
                                    color: selectedDestination == "Select Destination" ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ride Selector & Confirm Panel
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Destination: $selectedDestination', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(ridePrice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const Divider(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isBooking ? null : _startBookingProcess,
                      child: Text(
                        isBooking ? 'Searching Driver...' : 'Book RideMitra Now',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
