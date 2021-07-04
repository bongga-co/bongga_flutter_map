/// Desctiption of a state change
class MainControllerChange {
  MainControllerChange({required this.name, required this.value, this.from});

  final String name;
  final dynamic value;
  final Function? from;

  @override
  String toString() => '$name $value from $from';
}
