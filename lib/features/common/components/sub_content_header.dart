import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';

class SubContentHeaderBox extends StatelessWidget {
  final String? imagePath;
  final String title;

  const SubContentHeaderBox({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imagePath != null
            ? CustomContainer(
              padding: EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(6),
              child: ImageIcon(
                AssetImage(imagePath!),
                color: AppColors.black,
                size: 16,
              ),
            )
            : SizedBox.shrink(),
        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
