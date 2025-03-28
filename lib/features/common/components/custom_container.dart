import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final bool enableBorder;
  final Color? color;
  final double? width;
  final double? height;

  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.enableBorder = true,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border:
            enableBorder ? Border.all(color: AppColors.gray, width: 1) : null,
      ),
      child: child,
    );
  }
}
