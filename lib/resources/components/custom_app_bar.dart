import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rise_college/resources/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleWidget;
  final List<Widget>? action;
  final Widget? leading;
  const CustomAppBar({super.key, required this.titleWidget, this.action,  this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 8,
      backgroundColor: Colors.transparent,
      leading: leading,
      actions: action,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
       gradient: LinearGradient(
           colors: [
             AppColors.darkMaroon,AppColors.mediumMaroon,AppColors.lightMaroon,
             // Colors.blue[900]!, Colors.blue[600]!, Colors.blue[400]!,
           ],
         begin: Alignment.topLeft,
         end: AlignmentGeometry.bottomRight,
       ),
          boxShadow: [
            BoxShadow(
              // color: Colors.black.withOpacity(0.2),
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: Offset(0, 4),
            )
          ]
        ),
      ),
      title: DefaultTextStyle(style:  GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
        child: titleWidget,
      ),


    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
