import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:orah_pharmacy/services/global.dart';

class MapService {
  static Future<void> getLocation(
      BuildContext context, VoidCallback setStateCallback) async {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return MapLocationPicker(
            compassEnabled: true,
            hideMapTypeButton: true,
            hideMoreOptions: true,
            apiKey: "AIzaSyC_sB5cFNeWspf1frh_7G5LsGgju5jdxv4",
            popOnNextButtonTaped: true,
            currentLatLng: const LatLng(24.8607, 67.0011),
            onNext: (GeocodingResult? result) {
              if (result != null) {
                setStateCallback();
                Global.addressController.text = result.formattedAddress ?? "";
                Global.latitude = result.geometry.location.lat;
                Global.longitude = result.geometry.location.lng;
              }
            },
          );
        },
      ),
    );
  }
}
