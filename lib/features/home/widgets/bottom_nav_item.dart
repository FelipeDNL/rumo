import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const BottomNavItem({
    required this.icon, 
    required this.label, 
    this.selected = false,
    this.onTap, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Color(0xFF4E61F6) : Colors.grey;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
          ),
          Text(
              label,
              style: TextStyle(
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}