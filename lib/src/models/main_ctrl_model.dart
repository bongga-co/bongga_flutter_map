import 'package:flutter/foundation.dart';

/// Desctiption of a state change
class MainControllerChange {

  MainControllerChange({ 
    @required this.name, 
    @required this.value, 
    this.from
  }) : assert(name != null);

  final String name;
  final dynamic value;
  final Function from;

  @override
  String toString() {
    return "${this.name} ${this.value} from ${this.from}";
  }
}
