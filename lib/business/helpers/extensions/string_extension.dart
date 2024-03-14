extension Capitalize on String {
  String get capitalize => substring(0, 1).toUpperCase() + substring(1, length);
}