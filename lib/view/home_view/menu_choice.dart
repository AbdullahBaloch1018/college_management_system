/// New HelloSVG
library;

import 'package:flutter/material.dart';

// This is a simple data class (not a widget) to hold information for each menu choice.
// It includes the name, SVG path, color, size, and the page to navigate to.
class MenuChoice {
  final String name;
  final String svgAssetPath;
  final Color color;
  final double height;
  final double width;
  final Widget Function() destinationPageBuilder; // Changed to builder

  const MenuChoice({
    required this.name,
    required this.svgAssetPath,
    required this.color,
    required this.height,
    required this.width,
    required this.destinationPageBuilder,
  });
}
