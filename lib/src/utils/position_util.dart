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
        position = await _glocator.getCurrentPosition(
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

    if(isEnabled) {
      final opts = LocationOptions(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );

      stream = _glocator.getPositionStream(opts).asBroadcastStream();
    }

    return stream;
  }

  static Stream<Position> getPositionStream({
    int timeInterval = 3000, 
    int distanceFilter = 1 
  }) {

  final opts = LocationOptions(
    accuracy: LocationAccuracy.best,
    timeInterval: timeInterval,
    distanceFilter: distanceFilter
  );

  Stream<Position> positionStream = Geolocator().getPositionStream(opts)
      .asBroadcastStream();

  return positionStream;
}
}
