import 'package:geolocator/geolocator.dart';

class PositionUtil {
  static final _glocator = Geolocator();

  static Future<bool> isLocationServicesEnabled() async {
    final status  = await _glocator.checkGeolocationPermissionStatus();
    return (status == GeolocationStatus.granted);
  }

  static Future<Position> getLocation() async {
    Position position;
    final bool isEnabled = await isLocationServicesEnabled();
    
    if(isEnabled) {
      position = await _glocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.high
      );
    }

    return position;
  }

  /// Initialize the position stream
  static Future<Stream<Position>> getPositionUpdates() async {

    Stream<Position> stream;
    final isEnabled = await isLocationServicesEnabled();

    if(isEnabled) {
      final opts = LocationOptions(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
        timeInterval: 3000
      );

      stream = _glocator.getPositionStream(opts).asBroadcastStream();
    }

    return stream;
  }
}
