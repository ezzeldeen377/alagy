import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowLocationScreen extends StatefulWidget {
  final double lat;
  final double lng;

  const ShowLocationScreen({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<ShowLocationScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final LatLng doctorLocation = LatLng(widget.lat, widget.lng);
        final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Location'),
        backgroundColor: AppColor.tealNew,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: doctorLocation,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('doctor_location'),
            position: doctorLocation,
            infoWindow: InfoWindow(title: 'Doctor Location'),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
            if (isDark) {
                controller.setMapStyle(AppConstants.darkMapStyle);
              } else {
                controller.setMapStyle(null);
              }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}