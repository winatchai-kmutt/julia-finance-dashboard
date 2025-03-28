import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.gray, thickness: 1);
  }
}
