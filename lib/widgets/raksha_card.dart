import 'package:flutter/material.dart';
import 'package:raksha_ai/core/colors.dart';

class RakshaCard extends StatelessWidget {
  final Widget child;
  final bool isEmerald;
  final bool isGlass;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final IconData? backgroundIcon;
  final double backgroundIconSize;
  final Offset backgroundIconOffset;
  final double backgroundIconOpacity;
  final Widget? backgroundWidget;

  const RakshaCard({
    super.key,
    required this.child,
    this.isEmerald = false,
    this.isGlass = false,
    this.color,
    this.padding,
    this.backgroundIcon,
    this.backgroundIconSize = 140,
    this.backgroundIconOffset = const Offset(0.85, 0.45), // 0.0 to 1.0 relative
    this.backgroundIconOpacity = 0.15,
    this.backgroundWidget,
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
          child: Stack(
            children: [
              // Background Decorations
              if (backgroundIcon != null)
                Positioned(
                  right: -backgroundIconSize * (1 - backgroundIconOffset.dx),
                  bottom: -backgroundIconSize * (1 - backgroundIconOffset.dy),
                  child: Opacity(
                    opacity: backgroundIconOpacity,
                    child: Icon(
                      backgroundIcon,
                      size: backgroundIconSize,
                      color: isEmerald || isGlass ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              if (backgroundWidget != null) backgroundWidget!,
              
              // Foreground Content
              Padding(
                padding: padding ?? const EdgeInsets.all(20),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
