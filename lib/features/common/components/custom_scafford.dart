import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomScafford extends StatefulWidget {
  final Widget child;
  final bool isCashFlowPage;
  final bool isInvoicesPage;
  const CustomScafford({
    super.key,
    required this.child,
    this.isCashFlowPage = false,
    this.isInvoicesPage = false,
  });

  @override
  State<CustomScafford> createState() => _CustomScaffordState();
}

class _CustomScaffordState extends State<CustomScafford> {
  /*
  RESPONSIVE CONCEPT from one design with macbook pro screen
  เนื่องจาก Design มีแค่ 1 size + development on macbook
  และซึ่งยังไม่มี  Responsive design
  วิะีที่ทำให้ ยังคงรักษาขนาด content บน web ได้คือ เพิ่ม scrolling 
  ทั้ง Vertical, Horizontal
  * ใน แต่ละ Widget ถูกพัฒนาด้วย Flexible size หรือขยาหดตาม Parent
  ดังนั้นจึงต้องกำหนด Sized box screen ด้วย macbook screen size
  เพื่อมอบ contraint ให้ SingleChildScrollingVew
  จึงกำหนดให้ size ที่พอดีของ web คือ screen size macbook
  from mac screen size
  Left, Tab bar 1 : W=1512/5
  Right, main content 5 :  W=1512 - 1512/5
  */

  // from padding top+bottm = 8, left + right = 8
  final double macScreenWidth = 1512 - 8;
  final double macScreenHeight = 857 - 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Container(
          width: macScreenWidth,
          height: macScreenHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.greyLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      // from bottom + top = 8
                      height: macScreenHeight - 8,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: _LeftTapBars(
                          isCashFlowPage: widget.isCashFlowPage,
                          isInvoicesPage: widget.isInvoicesPage,
                        ),
                      ),
                    ),
                  ),
                ),
                // CONTENT
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        // from padding all 4 top + bottom = 8, left + right = 8
                        width: macScreenWidth - (macScreenWidth / 5) - 8,
                        height: macScreenHeight - 8,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeftTapBars extends StatefulWidget {
  final bool isCashFlowPage;
  final bool isInvoicesPage;

  const _LeftTapBars({
    required this.isCashFlowPage,
    required this.isInvoicesPage,
  });

  @override
  State<_LeftTapBars> createState() => __LeftTapBarsState();
}

class __LeftTapBarsState extends State<_LeftTapBars> {
  final searchingController = TextEditingController();

  bool isShowGeneralList = true;
  bool isShowOthersList = true;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          children: [
            // Logo, Text
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                spacing: 8,
                children: [
                  Image.asset('assets/images/logo.png', width: 24),
                  if (constraint.maxWidth > 165)
                    Text(
                      "Julia Corporation",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Searching bar
            CustomSearchingBar(searchingController: searchingController),

            SizedBox(height: 16),

            // General header
            NavigatorHeadBox(
              isArrowUp: !isShowGeneralList,
              text: 'GENERAL',
              onTap: () {
                setState(() {
                  isShowGeneralList = !isShowGeneralList;
                });
              },
            ),

            // General list
            Visibility(
              visible: isShowGeneralList,
              child: Column(
                spacing: 4,
                children: [
                  NavigatorTapBox(
                    isTap: widget.isCashFlowPage,
                    iconPath: 'assets/icons/chart_alt.png',
                    title: 'Cash Flow',
                    enable: true,
                    onTap: () {
                      context.go('/cash-flow');
                    },
                  ),
                  NavigatorTapBox(
                    isTap: widget.isInvoicesPage,
                    iconPath: 'assets/icons/print.png',
                    title: 'Invoices',
                    enable: true,
                    onTap: () {
                      context.go('/create-invoice');
                    },
                  ),
                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/doughnut_chart.png',
                    title: 'Dashboard',
                    onTap: () {},
                  ),

                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/date_today.png',
                    title: 'Upcoming Payments',
                    onTap: () {},
                  ),
                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/group.png',
                    title: 'Team Activity',
                    onTap: () {},
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            // Others header
            NavigatorHeadBox(
              text: 'OTHERS',
              isArrowUp: !isShowOthersList,
              onTap: () {
                setState(() {
                  isShowOthersList = !isShowOthersList;
                });
              },
            ),
            // TODO MAKE SLIDE
            // Others list
            Visibility(
              visible: isShowOthersList,
              child: Column(
                spacing: 4,
                children: [
                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/nesting.png',
                    title: 'Integation',
                    onTap: () {},
                  ),
                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/question.png',
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  NavigatorTapBox(
                    isTap: false,
                    iconPath: 'assets/icons/setting_line.png',
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Spacer(),

            CustomContainer(
              padding: EdgeInsets.all(8),
              child: Row(
                spacing: 8,
                children: [
                  if (constraint.maxWidth > 250)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/images/avatar.png', width: 36),
                    ),
                  if (constraint.maxWidth > 250)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'Winatchai Chan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Software developer',
                          style: TextStyle(
                            color: AppColors.greyDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (constraint.maxWidth > 250) Spacer(),
                  IconButton(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      context.go('/auth');
                    },
                    icon: ImageIcon(
                      AssetImage('assets/icons/sign_out_squre.png'),
                      color: AppColors.greyDark,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomSearchingBar extends StatelessWidget {
  final TextEditingController searchingController;
  final bool enableFindCommand;
  final String hintText;
  const CustomSearchingBar({
    super.key,
    required this.searchingController,
    this.hintText = 'Search...',
    this.enableFindCommand = true,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: searchingController,
      onTap: () {},
      onChanged: (_) {},
      constraints: BoxConstraints(maxHeight: 36),
      leading: const Icon(
        CupertinoIcons.search,
        color: AppColors.greyDark,
        size: 16,
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      ),
      hintText: hintText,
      hintStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(color: AppColors.greyDark, fontSize: 14),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(AppColors.white),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(color: AppColors.gray, width: 0.5),
      ),
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      trailing: [
        enableFindCommand
            ? Material(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(4),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(),
                  child: Text(
                    "⌘F",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}

class NavigatorHeadBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isArrowUp;
  const NavigatorHeadBox({
    super.key,
    required this.text,
    required this.onTap,
    required this.isArrowUp,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.greenPastel.withValues(alpha: 0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(
                isArrowUp
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down,
                color: AppColors.black,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: AppColors.greyDark)),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigatorTapBox extends StatelessWidget {
  final bool isTap;
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final bool enable;

  const NavigatorTapBox({
    super.key,
    required this.isTap,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.enable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      child: Material(
        color: isTap ? AppColors.tealLight : AppColors.greyLight,
        clipBehavior: Clip.antiAlias,
        shape:
            isTap
                ? Border(left: BorderSide(color: AppColors.tealDark, width: 4))
                : null,
        child: InkWell(
          onTap: !isTap && enable ? onTap : null,
          splashColor: AppColors.greenPastel.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(iconPath),
                  color: enable ? AppColors.black : AppColors.greyDark,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style:
                      enable
                          ? TextStyle(color: AppColors.black, fontSize: 14)
                          : TextStyle(
                            color: AppColors.greyDark,
                            fontSize: 14,
                            textBaseline: TextBaseline.ideographic,

                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2, // ความหนาของเส้น
                            decorationColor:
                                AppColors.greyDark, // สีของเส้นขีดฆ่า
                          ),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
