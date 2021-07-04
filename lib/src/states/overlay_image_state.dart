import 'package:flutter_map/flutter_map.dart';

class OverlayImageState {
  OverlayImageState({required this.mapController, required this.notify});

  final MapController mapController;
  final Function notify;
  final Map<String, OverlayImage> _namedImages = {};

  var _images = <OverlayImage>[];

  List<OverlayImage> get images => _images;

  Map<String, OverlayImage> get namedImages => _namedImages;

  Future<void> addImage({
    required OverlayImage image,
    required String name,
  }) async {
    try {
      _namedImages[name] = image;
    } catch (e) {
      throw Exception('Can not add image: $e');
    }

    try {
      _buildImages();
    } catch (e) {
      throw Exception('Can not build for add image: $e');
    }

    notify('updateImages', _images, addImage);
  }

  /// Remove an image from the map
  Future<void> removeImage({required String name}) async {
    try {
      final res = _namedImages.remove(name);

      if (res == null) {
        throw Exception('Image $name not found in map');
      }
    } catch (e) {
      // throw ("Can not remove image: $e");
    }

    try {
      _buildImages();
    } catch (e) {
      throw Exception('Can not build for remove image: $e');
    }

    notify('updateImages', _images, removeImage);
  }

  /// Add multiple images on the map
  Future<void> addImages({required Map<String, OverlayImage> images}) async {
    try {
      images.forEach((k, v) => _namedImages[k] = v);
    } catch (e) {
      throw Exception('Can not add images: $e');
    }
    _buildImages();
    notify('updateImages', _images, addImages);
  }

  /// Remove multiple images from the map
  Future<void> removeImages({required List<String> names}) async {
    names.forEach(_namedImages.remove);
    _buildImages();
    notify('updateImages', _images, removeImages);
  }

  void _buildImages() {
    var listImages = <OverlayImage>[];
    for (var k in _namedImages.keys) {
      listImages.add(_namedImages[k]!);
    }
    _images = listImages;
  }
}
