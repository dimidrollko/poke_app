import 'package:flutter/material.dart';

extension BuildContextSizeExtensions on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get width => size.width; // size._dx

  bool get isLargeScreen => width > 600;

  double get height => size.height; // size._dy
}

extension BuildContextThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}
