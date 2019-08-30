import 'package:geolocator/geolocator.dart';

class PositionUtil {
  static final _glocator = Geolocator();

  static Future<bool> isLocationServicesEnabled() async {
    return await _glocator.isLocationServiceEnabled();
  }

  static Future<Position> getLocation() async {
    Position position;
    final bool isEnabled = await isLocationServicesEnabled();
    
    try {

      if(isEnabled) {
        position = await _glocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.high
        );
      }

    } catch(e) {
      
    }
    
    return position;
  }

  /// Initialize the position stream
  static Future<Stream<Position>> getPositionUpdates() async {

    Stream<Position> stream;
    final isEnabled = await isLocationServicesEnabled();

    try {

      if(isEnabled) {
        final opts = LocationOptions(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
        );

        stream = _glocator.getPositionStream(opts).asBroadcastStream();
      }

    } catch(e) {

    }

    return stream;
  }

  static Stream<Position> getPositionStream({ int interval = 3000, int distance }) {

    Geolocator geolocator = Geolocator();
    LocationOptions options;

    if (distance == null) {
      options = LocationOptions(
          accuracy: LocationAccuracy.best, timeInterval: interval);
    } else {
      options = LocationOptions(
          accuracy: LocationAccuracy.best, distanceFilter: distance);
    }

    Stream<Position> stream =
        geolocator.getPositionStream(options).asBroadcastStream();

    return stream;
  }
}
