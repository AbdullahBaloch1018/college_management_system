import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'menu_choice.dart';

class SelectCard extends StatelessWidget {
  final MenuChoice choice;

  const SelectCard({super.key, required this.choice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: choice.color.withValues(alpha: 0.15),
            child: SvgPicture.asset(
              choice.svgAssetPath,
              height: choice.height,
              width: choice.width,
              colorFilter: ColorFilter.mode(choice.color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            choice.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
