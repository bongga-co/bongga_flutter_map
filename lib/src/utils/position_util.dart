import 'package:geolocator/geolocator.dart';

class PositionUtil {
  static final _geoLocator = GeolocatorPlatform.instance;

  static Future<bool> isLocationServicesEnabled() async {
    return _geoLocator.isLocationServiceEnabled();
  }

  static Future<Position?> getLocation() async {
    final isEnabled = await isLocationServicesEnabled();
    Position? position;

    try {
      if (isEnabled) {
        position = await _geoLocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return position;
  }

  /// Initialize the position stream
  static Future<Stream<Position>?> getPositionUpdates() async {
    final isEnabled = await isLocationServicesEnabled();
    Stream<Position>? stream;

    try {
      if (isEnabled) {
        stream = _geoLocator
            .getPositionStream(
              locationSettings: const LocationSettings(distanceFilter: 1),
            )
            .asBroadcastStream();
      }
    } catch (e) {
      print(e);
    }

    return stream;
  }

  static Stream<Position> getPositionStream({int interval = 3000, int? dist}) {
    final geoLocator = GeolocatorPlatform.instance;

    return geoLocator
        .getPositionStream(
          locationSettings: LocationSettings(
            distanceFilter: dist ?? 0,
            timeLimit: Duration(milliseconds: dist != null ? interval : 0),
          ),
        )
        .asBroadcastStream();
  }
}
