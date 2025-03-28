import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';

class LightButton extends StatelessWidget {
  final String title;
  final String imageIconPath;
  final Color? color;
  final Color? contentColor;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  const LightButton({
    super.key,
    required this.title,
    required this.imageIconPath,
    this.color,
    this.contentColor,
    this.textStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onTap ?? () {},
      enableBorder: color == null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: color ?? AppColors.white,
      child: Row(
        spacing: 6,
        children: [
          ImageIcon(
            AssetImage(imageIconPath),
            size: 16,
            color: contentColor ?? AppColors.black,
          ),
          Text(
            title,
            style:
                textStyle ??
                TextStyle(color: contentColor ?? AppColors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
