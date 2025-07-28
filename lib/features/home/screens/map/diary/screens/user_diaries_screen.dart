import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class UserDiariesScreen extends StatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  State<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends State<UserDiariesScreen> {
  final location = Location();
  final MapController mapController = MapController();

  bool isMapReady = false;

  LatLng? userCoordinates;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await location.changeSettings(accuracy: LocationAccuracy.balanced);

      final userPosition = await location.getLocation();
      if (userPosition.latitude == null || userPosition.longitude == null)
        return;

      setState(() {
        userCoordinates = LatLng(
          userPosition.latitude!,
          userPosition.longitude!,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: userCoordinates ?? LatLng(0, 0),
          onMapReady: () {
            isMapReady = true;
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'br.com.felipe.rumo',
          ),
        ],
      ),
    );
  }
}
