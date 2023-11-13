import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class GPSRepository {
  GPSRepository();

  Future<String> getGPSCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 跳出打開定位的提示 dialog
      bool isEnableGPS = await Location().requestService();
      if (!isEnableGPS) {
        return Future.error(
            'Location services are disabled. Please enable location services.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied. Please provide permission.');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    String coordinate =
        '${position.latitude.toStringAsFixed(10)},${position.longitude.toStringAsFixed(10)}';

    return coordinate;
  }
}
