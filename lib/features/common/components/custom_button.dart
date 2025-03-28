import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final Color? color;
  final Color? splashColor;
  final bool enableBorder;
  final bool enableColorHover;
  final bool enableTap;
  final BorderRadius? borderRadius;
  const CustomButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.color,
    this.splashColor,
    this.enableBorder = true,
    this.enableColorHover = true,
    this.enableTap = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.white,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        hoverColor: enableColorHover ? null : Colors.transparent,
        onTap: enableTap ? onTap : null,
        splashColor: splashColor,
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border:
                enableBorder
                    ? Border.all(color: AppColors.gray, width: 1)
                    : null,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }
}
