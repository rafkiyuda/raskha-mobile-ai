import 'package:flutter/material.dart';
import 'package:raksha_ai/core/colors.dart';

class RakshaCard extends StatelessWidget {
  final Widget child;
  final bool isEmerald;
  final bool isGlass;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const RakshaCard({
    super.key,
    required this.child,
    this.isEmerald = false,
    this.isGlass = false,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? (isEmerald ? RakshaColors.primary : (isGlass ? Colors.white.withOpacity(0.2) : Colors.white));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Small margin for shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isGlass ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: isGlass ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
