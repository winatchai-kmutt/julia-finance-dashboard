import 'package:financial_dashboard/features/cash_flow/presentation/pages/cash_flow_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CashFlowPageRouter {
  final String paht;
  final GlobalKey<NavigatorState> navigatorKey;

  CashFlowPageRouter({required this.paht, required this.navigatorKey});

  GoRoute get route => GoRoute(
    parentNavigatorKey: navigatorKey,
    path: paht,
    pageBuilder: (context, state) => NoTransitionPage(child: CashFlowPage()),
  );
}
