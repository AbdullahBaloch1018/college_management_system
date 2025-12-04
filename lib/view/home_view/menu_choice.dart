/// Old HelloSVG
/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Icons which we are using at our home Screen
class HelloSvg extends StatelessWidget {
  final String svgAssetPath;
  final String name;
  final Color color;
  // final VoidCallbackAction onTap;
  final double width;
  final double height;
  final Widget destinationPage;

  // final String routeName;
  // final Icon icon;
  //final String ontap;
  const HelloSvg({
    super.key,
    required this.name,
    required this.svgAssetPath,
    required this.color,
    // required this.onTap,
    required this.width,
    required this.height,
    required this.destinationPage,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 90),
            SingleChildScrollView(
              child: SvgPicture.asset(
                svgAssetPath,
                height: height,
                width: width,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                //allowDrawingOutsideViewBox: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(name),
          ],
        ),
      ],
    );
  }
}
*/
/// New HelloSVG
import 'package:flutter/material.dart';

// This is a simple data class (not a widget) to hold information for each menu choice.
// It includes the name, SVG path, color, size, and the page to navigate to.
class MenuChoice {
  final String name;
  final String svgAssetPath;
  final Color color;
  final double height;
  final double width;
  final Widget Function() destinationPageBuilder;  // Changed to builder

  const MenuChoice({
    required this.name,
    required this.svgAssetPath,
    required this.color,
    required this.height,
    required this.width,
    required this.destinationPageBuilder,
  });
}