import 'package:geolocator/geolocator.dart';

class PositionUtil {
  static final glocator = Geolocator();

  /// Initialize the position stream
  static Stream<Position> getPositionStream({
    int timeInterval = 3000, 
    int distanceFilter
  }) {
    Stream<Position> positionStream = glocator.getPositionStream(
      LocationOptions(
        accuracy: LocationAccuracy.best,
        timeInterval: timeInterval,
        distanceFilter: distanceFilter
      )
    ).asBroadcastStream();
    return positionStream;
  }
}
