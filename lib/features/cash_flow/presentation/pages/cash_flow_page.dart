import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/cash_flow/presentation/components/full_line_chart.dart';
import 'package:financial_dashboard/features/cash_flow/presentation/components/line_chart.dart';
import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/common/components/custom_scafford.dart';
import 'package:financial_dashboard/features/common/components/light_button.dart';
import 'package:financial_dashboard/features/common/components/sub_content_header.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:intl/intl.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CashFlowPage extends StatelessWidget {
  const CashFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchingController = TextEditingController();
    print(context.read<AuthCubit>().currentUser);
    return Column(
      spacing: 8,
      children: [
        // header
        _Header(),

        // current balance, net clash,  quick access
        Expanded(
          flex: 2,
          child: Row(
            spacing: 8,
            children: [
              // current balance
              Expanded(flex: 2, child: _CurrentBalance()),

              // Net chash flow
              Expanded(flex: 4, child: _NetChashFlow()),

              // Quick access
              Expanded(flex: 2, child: _QuickAccess()),
            ],
          ),
        ),

        // chash flow, Top transection
        Expanded(
          flex: 5,
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                flex: 3,
                // chash flow breakdown
                child: _ChashFlowBreakdown(),
              ),
              Expanded(
                flex: 2,
                // top transactions
                child: _TopTransactions(),
              ),
            ],
          ),
        ),
        // recent clash flow,  AI Insign
        Expanded(
          flex: 3,
          child: Row(
            spacing: 8,
            children: [
              // recent cash flow
              Expanded(
                flex: 3,
                child: _RecentCashFlow(
                  searchingController: searchingController,
                ),
              ),
              // ai insight
              _AIInsight(),
            ],
          ),
        ),
      ],
    );
  }
}

class _AIInsight extends StatelessWidget {
  const _AIInsight();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Color(0xff015862), Color(0xff0c90a1)],
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xfff09819), Color(0xffedde5d)],
                      stops: [0, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: ImageIcon(
                    AssetImage('assets/icons/fram.png'),
                    color: AppColors.greyOffWhite,
                    size: 16,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "AI Insight",
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: ImageIcon(
                    AssetImage('assets/icons/chat_fill.png'),
                    color: AppColors.greyOffWhite,
                    size: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: _AIChildBox(
                title: "Cash Flow Anomaly Detected",
                description:
                    "The Office Rent expense is 50% higher then usual. Check for any one-off fees",
              ),
            ),
            SizedBox(height: 4),

            Expanded(
              child: _AIChildBox(
                title: "Potential Cash Flow Shortage",
                description:
                    "You cash flow could face a shortage due to higher operational costs.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIChildBox extends StatelessWidget {
  final String title;
  final String description;
  const _AIChildBox({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white.withValues(alpha: 0.1),
      ),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: GradientIcon(
              offset: Offset(0, 0),
              size: 18,
              icon: Icons.ballot_outlined,
              gradient: LinearGradient(
                colors: [
                  Color(0xffffd1dc), // Pastel Pink
                  Color(0xffa2d2ff), // Pastel Blue
                  Color(0xfffbc687), // Pastel Orange
                  Color(0xffc1e1c1), // Pastel Green
                  Color(0xfff5c2e7), // Pastel Purple
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                GradientText(
                  title,
                  style: TextStyle(fontSize: 14),
                  colors: [
                    Color(0xffffd1dc), // Pastel Pink
                    Color(0xffa2d2ff), // Pastel Blue
                    Color(0xfffbc687), // Pastel Orange
                    Color(0xffc1e1c1), // Pastel Green
                    Color(0xfff5c2e7), // Pastel Purple
                  ],
                ),
                Text(
                  description,
                  maxLines: 3,
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentCashFlow extends StatefulWidget {
  final TextEditingController searchingController;
  const _RecentCashFlow({required this.searchingController});

  @override
  State<_RecentCashFlow> createState() => _RecentCashFlowState();
}

class _RecentCashFlowState extends State<_RecentCashFlow> {
  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        spacing: 4,
        children: [
          Row(
            children: [
              Expanded(
                child: SubContentHeaderBox(
                  imagePath: 'assets/icons/folder_open.png',
                  title: "Recent Cash Flow",
                ),
              ),
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: CustomSearchingBar(
                        searchingController: widget.searchingController,
                        hintText: 'Searching',
                        enableFindCommand: false,
                      ),
                    ),
                    CustomButton(
                      onTap: () {},
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        spacing: 4,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/filter_big.png'),
                            size: 16,
                            color: AppColors.black,
                          ),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      onTap: () {},
                      child: Row(
                        spacing: 4,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/filter_alt.png'),
                            size: 16,
                            color: AppColors.black,
                          ),
                          Text(
                            'Sort by',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _RecentCFHeadTable(
            value: isAllSelected,
            onTap: (bool? value) {
              setState(() {
                isAllSelected = value!;
              });
            },
          ),
          Divider(color: AppColors.gray, height: 1),
          _RecentCFRow(
            name: 'Payment from Client A',
            time: 'Today, 12:30 AM',
            category: 'Income',
            amount: 6500,
            onChanged: (bool? value) {},
            isSelected: isAllSelected,
          ),
          Divider(color: AppColors.gray, height: 1),
          _RecentCFRow(
            name: 'Payment from Client A',
            time: 'Today, 12:30 AM',
            category: 'Outcome',
            amount: -4500,
            onChanged: (bool? value) {},
            isSelected: isAllSelected,
          ),
          Divider(color: AppColors.gray, height: 1),
          _RecentCFRow(
            name: 'Payment from Client A',
            time: 'Today, 12:30 AM',
            category: 'Outcome',
            amount: -800,
            onChanged: (bool? value) {},
            isSelected: isAllSelected,
          ),
        ],
      ),
    );
  }
}

class _RecentCFRow extends StatelessWidget {
  final ValueChanged<bool?> onChanged;
  final bool isSelected;
  final String name;
  final String time;
  final String category;
  final double amount;
  const _RecentCFRow({
    required this.onChanged,
    required this.name,
    required this.time,
    required this.category,
    required this.amount,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CashFlowCheckBox(value: isSelected, onChanged: onChanged),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(color: AppColors.black, fontSize: 12),
              ),
              Text(
                time,
                style: TextStyle(color: AppColors.greyDark, fontSize: 10),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        category,
                        style: TextStyle(color: AppColors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  amount.isNegative
                      ? '-\$${NumberFormat('#,###').format(amount.abs())}'
                      : '+\$${NumberFormat('#,###').format(amount)}',
                  style: TextStyle(
                    color:
                        amount.isNegative
                            ? AppColors.redMuted
                            : AppColors.greenDeep,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.greenPastel,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          color: AppColors.greenDeep,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onTap: () {},
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        spacing: 4,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/arhive_alt_add.png'),
                            size: 16,
                            color: AppColors.black,
                          ),
                          Text(
                            'receip.pdf',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: ImageIcon(
                        AssetImage('assets/icons/meatballs_menu.png'),
                        size: 16,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CashFlowCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isHead;
  const _CashFlowCheckBox({
    required this.value,
    required this.onChanged,
    this.isHead = false,
  });

  @override
  State<_CashFlowCheckBox> createState() => _CashFlowCheckBoxState();
}

class _CashFlowCheckBoxState extends State<_CashFlowCheckBox> {
  late bool isSelected;
  late bool tempValue;

  @override
  void initState() {
    super.initState();
    tempValue = widget.value;
    isSelected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    if (tempValue != widget.value && !widget.isHead) {
      tempValue = widget.value;
      setState(() {
        isSelected = widget.value;
      });
    }
    return Checkbox(
      value: isSelected,
      onChanged: (value) {
        widget.onChanged(value);

        setState(() {
          isSelected = value!;
        });
      },
      checkColor: AppColors.tealDark,
      activeColor: AppColors.greenPastel,
      splashRadius: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.black, width: 1),
    );
  }
}

class _RecentCFHeadTable extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onTap;

  const _RecentCFHeadTable({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CashFlowCheckBox(value: value, onChanged: onTap, isHead: true),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            'Transaction',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Category',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Amount',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Status',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Receip',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopTransactions extends StatelessWidget {
  const _TopTransactions();

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      imagePath: 'assets/icons/bubble.png',
      title: 'Top Transactions',
      child: Column(
        spacing: 8,
        children: [
          SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: _TransactionBox(
              title: 'Highest Income',
              description: 'Payment for Service A',
              amountOfMoney: 40000,
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 3,
            child: _TransactionBox(
              title: 'Largest Expense',
              description: 'Purchase of Office Equipment',
              amountOfMoney: 12000,
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 3,
            child: _TransactionBox(
              title: 'Most Frequent Vendor',
              description: 'Subscription to Cloud Service',
              amountOfMoney: 34000,
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 3,
            child: _TransactionBox(
              title: 'Top Recurring Payment',
              description: 'Monthly Lease Payment for Office Space',
              amountOfMoney: 5000,
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomButton(
              onTap: () {},
              color: AppColors.tealDark,
              enableBorder: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    'See more',
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                  Icon(Icons.arrow_forward, size: 16, color: AppColors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionBox extends StatelessWidget {
  final String title;
  final String description;
  final int amountOfMoney;
  final VoidCallback onTap;
  const _TransactionBox({
    required this.title,
    required this.description,
    required this.amountOfMoney,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onTap,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: AppColors.greyDark, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          Text(
            '\$${NumberFormat('#,###').format(amountOfMoney)}',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.chevron_right, size: 24, color: AppColors.black),
        ],
      ),
    );
  }
}

class _ChashFlowBreakdown extends StatefulWidget {
  const _ChashFlowBreakdown();

  @override
  State<_ChashFlowBreakdown> createState() => _ChashFlowBreakdownState();
}

class _ChashFlowBreakdownState extends State<_ChashFlowBreakdown> {
  bool isShowingMainData = true;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: SubContentHeaderBox(
                  imagePath: 'assets/icons/bubble.png',
                  title: "Cash Flow Breakdown",
                ),
              ),
              _CashFlowTabBar(
                onTap: (bool isExpense) {
                  setState(() {
                    isShowingMainData = !isShowingMainData;
                  });
                },
              ),
              _ToggleButton(onTap: (bool isSelected) {}),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "\$983,112",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    _StatusBox(
                      imageIcon: AssetImage('assets/icons/bubble.png'),
                      value: 10.8,
                    ),
                    Spacer(),
                    Text(
                      "Across all accouts",
                      style: TextStyle(color: AppColors.black, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Expanded(
                  child: CustomLineChart(isShowingMainData: isShowingMainData),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: _ChartTageBox(
                  color: Colors.blue[200]!,
                  title: 'Salaries',
                  doubleNumber: 15.583,
                  decimalNumber: 45,
                ),
              ),
              Expanded(
                child: _ChartTageBox(
                  color: Colors.brown[200]!,
                  title: 'Rent',
                  doubleNumber: 87.435,
                  decimalNumber: 32,
                ),
              ),
              Expanded(
                child: _ChartTageBox(
                  color: Colors.green[200]!,
                  title: 'Utilities',
                  doubleNumber: 9.324,
                  decimalNumber: 08,
                ),
              ),
              Expanded(
                child: _ChartTageBox(
                  color: Colors.red[200]!,
                  title: 'Marketing',
                  doubleNumber: 2.343,
                  decimalNumber: 11,
                ),
              ),
              Expanded(
                child: _ChartTageBox(
                  color: Colors.amber[200]!,
                  title: 'Supplies',
                  doubleNumber: 1.395,
                  decimalNumber: 43,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      title: "Quick Access",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 8),
          Expanded(
            child: CustomButton(
              onTap: () {},
              enableBorder: false,
              color: AppColors.tealLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/line_in.png'),
                    size: 16,
                    color: AppColors.tealDark,
                  ),
                  Text(
                    "Add Income",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: CustomButton(
              onTap: () {},
              enableBorder: false,
              color: AppColors.tealLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/line_out.png'),
                    size: 16,
                    color: AppColors.tealDark,
                  ),
                  Text(
                    "Add Expense",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: CustomButton(
              onTap: () {},
              enableBorder: false,
              color: AppColors.tealLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/paper.png'),
                    size: 16,
                    color: AppColors.tealDark,
                  ),
                  Text(
                    "Manage Pending invoice",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetChashFlow extends StatelessWidget {
  const _NetChashFlow();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                SubContentHeaderBox(
                  title: "Net Crash Flow",
                  imagePath: 'assets/icons/bubble.png',
                ),
                Spacer(),
                Row(
                  spacing: 8,
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: 25235),
                      duration: Duration(milliseconds: 1000),
                      builder: (context, value, _) {
                        return Text(
                          "+\$${NumberFormat('#,###').format(value)}",
                          style: TextStyle(
                            color: AppColors.tealDark,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    _StatusBox(
                      imageIcon: AssetImage('assets/icons/bubble.png'),
                      value: 2.4,
                    ),
                  ],
                ),
                Text(
                  "It's \$1,245 better then last month!",
                  style: TextStyle(color: AppColors.black, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: FullLineChart(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentBalance extends StatelessWidget {
  const _CurrentBalance();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          SubContentHeaderBox(
            imagePath: 'assets/icons/bubble.png',
            title: "Current Account Balance",
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Text(
                "\$150,000",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _StatusBox(
                imageIcon: AssetImage('assets/icons/bubble.png'),
                value: 3.8,
              ),
            ],
          ),
          Text(
            "Across all accouts",
            style: TextStyle(color: AppColors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ChartTageBox extends StatelessWidget {
  final Color color;
  final String title;
  final double doubleNumber;
  final int decimalNumber;

  const _ChartTageBox({
    required this.color,
    required this.title,
    required this.doubleNumber,
    required this.decimalNumber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 4,
            children: [
              Container(width: 5, height: 5, color: color),
              Text(
                title,
                style: TextStyle(color: AppColors.black, fontSize: 12),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: "\$${doubleNumber.toString()}",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ".${decimalNumber.toString()}",
                  style: TextStyle(
                    color: AppColors.greyDark,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatefulWidget {
  final Function(bool isSelected) onTap;
  const _ToggleButton({required this.onTap});

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      enableColorHover: false,
      splashColor: Colors.transparent,
      padding: EdgeInsets.zero,
      enableBorder: false,
      onTap: () {
        widget.onTap(isSelected);
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Row(
        spacing: 4,
        children: [
          Text(
            "This week",
            style: TextStyle(color: AppColors.greyDark, fontSize: 12),
          ),
          Icon(
            isSelected
                ? CupertinoIcons.chevron_up
                : CupertinoIcons.chevron_down,
            color: AppColors.greyDark,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _CashFlowTabBar extends StatefulWidget {
  final ValueChanged<bool> onTap;
  const _CashFlowTabBar({required this.onTap});

  @override
  State<_CashFlowTabBar> createState() => _CashFlowTabBarState();
}

class _CashFlowTabBarState extends State<_CashFlowTabBar> {
  bool isExpense = true;

  void toggle() {
    widget.onTap(isExpense);
    setState(() {
      isExpense = !isExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 4,
        children: [
          CustomButton(
            onTap: toggle,
            enableTap: !isExpense,
            color: isExpense ? AppColors.white : AppColors.gray,
            splashColor: Colors.transparent,
            enableColorHover: false,
            enableBorder: false,
            child: Row(
              spacing: 4,
              children: [
                ImageIcon(
                  AssetImage('assets/icons/line_in.png'),
                  color: AppColors.black,
                  size: 16,
                ),
                Text(
                  'Expense',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            onTap: toggle,
            enableTap: isExpense,
            enableColorHover: false,
            enableBorder: false,
            splashColor: Colors.transparent,
            color: !isExpense ? AppColors.white : AppColors.gray,
            child: Row(
              spacing: 4,
              children: [
                ImageIcon(
                  AssetImage('assets/icons/line_out.png'),
                  color: AppColors.black,
                  size: 16,
                ),
                Text(
                  'Income',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final ImageProvider imageIcon;
  final double value;
  const _StatusBox({required this.imageIcon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greenPastel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 4,
        children: [
          ImageIcon(imageIcon, size: 16, color: AppColors.greenDeep),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 1000),
            builder: (context, value, _) {
              return Text(
                '${value.isNegative ? '-${value.toStringAsFixed(1)}' : '+${value.toStringAsFixed(1)}'}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenDeep,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  final Widget child;
  final String title;
  final String? imagePath;

  const ContentBox({
    super.key,
    required this.child,
    required this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          SubContentHeaderBox(imagePath: imagePath, title: title),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cash Flow",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Monitor your company's financial health with detailed income and expense tracking.",
              style: TextStyle(color: AppColors.black, fontSize: 12),
            ),
          ],
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/icons/bell_pin.png',
            width: 24,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 8),
        LightButton(
          title: 'Generate Report',
          imageIconPath: 'assets/icons/file_dock.png',
        ),
        SizedBox(width: 8),
        LightButton(
          title: 'Set Budgets',
          imageIconPath: 'assets/icons/add_round.png',
          color: AppColors.tealDark,
          contentColor: AppColors.white,
        ),
      ],
    );
  }
}
