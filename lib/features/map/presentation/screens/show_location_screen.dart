import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowLocationScreen extends StatefulWidget {
  final double lat;
  final double lng;

  const ShowLocationScreen({super.key, required this.lat, required this.lng});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<ShowLocationScreen> {
  GoogleMapController? _mapController;

  Future<void> _openGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${widget.lat},${widget.lng}&travelmode=driving";
    final Uri uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.generalError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure coordinates are finite to avoid native LatLng crashes
    final double safeLat = widget.lat.isFinite ? widget.lat : 30.0444;
    final double safeLng = widget.lng.isFinite ? widget.lng : 31.2357;
    final LatLng doctorLocation = LatLng(safeLat, safeLng);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.doctorDetailLocation,
          style: context.theme.textTheme.titleLarge?.copyWith(color: AppColor.whiteColor),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: doctorLocation,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('doctor_location'),
                position: doctorLocation,
                infoWindow: InfoWindow(title: context.l10n.doctorDetailLocation),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              try {
                if (isDark) {
                  controller.setMapStyle(AppConstants.darkMapStyle);
                } else {
                  controller.setMapStyle(null);
                }
              } catch (e) {
                debugPrint("Error setting map style: $e");
              }
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: CustomButton(
              buttonContent: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions, color: AppColor.whiteColor),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.goToGoogleMaps,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTapButton: _openGoogleMaps,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}