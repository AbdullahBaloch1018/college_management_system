import 'package:flutter/material.dart';

import '../app_colors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  // final VoidCallback onPress;
  final VoidCallback onPress;
  final bool loading;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lightMaroon.withValues(alpha : loading ? 0.7 : 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.white,
                  ),
                )
              : Text(title, style: TextStyle(color: AppColors.white)),
        ),
      ),
    );
  }
}
