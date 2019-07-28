import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

class OverlayImageState {
  OverlayImageState({
    @required this.mapController, 
    @required this.notify
  }) : assert(mapController != null);

  final MapController mapController;
  final Function notify;
  final Map<String, OverlayImage> _namedImages = {};

  var _images = <OverlayImage>[];
  
  List<OverlayImage> get images => _images;
  Map<String, OverlayImage> get namedImages => _namedImages;

  Future<void> addImage({
    @required OverlayImage image, 
    @required String name 
  }) async {
    if (image == null) throw ArgumentError("image must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      _namedImages[name] = image;
    } catch (e) {
      throw ("Can not add image: $e");
    }
    
    try {
      _buildImages();
    } catch (e) {
      throw ("Can not build for add image: $e");
    }
    
    notify("updateImages", _images, addImage);
  }

  /// Remove an image from the map
  Future<void> removeImage({ @required String name }) async {
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      final res = _namedImages.remove(name);

      if (res == null) {
        throw ("Image $name not found in map");
      }
    } catch (e) {
      //throw ("Can not remove image: $e");
    }

    try {
      _buildImages();
    } catch (e) {
      throw ("Can not build for remove image: $e");
    }
    
    notify("updateImages", _images, removeImage);
  }

  /// Add multiple images on the map
  Future<void> addImages({ @required Map<String, OverlayImage> images }) async {
    if (images == null) {
      throw (ArgumentError.notNull("images must not be null"));
    }

    if (images == null) throw ArgumentError("images must not be null");

    try {
      images.forEach((k, v) {
        _namedImages[k] = v;
      });
    } catch (e) {
      throw ("Can not add images: $e");
    }
    _buildImages();
    notify("updateImages", _images, addImages);
  }

  /// Remove multiple images from the map
  Future<void> removeImages({ @required List<String> names }) async {
    if (names == null) throw (ArgumentError.notNull("names must not be null"));

    names.forEach((name) {
      _namedImages.remove(name);
    });

    _buildImages();
    notify("updateImages", _images, removeImages);
  }

  void _buildImages() {
    var listImages = <OverlayImage>[];
    
    for (var k in _namedImages.keys) {
      listImages.add(_namedImages[k]);
    }

    _images = listImages;
  }
}