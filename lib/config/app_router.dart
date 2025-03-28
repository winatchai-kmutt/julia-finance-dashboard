import 'package:financial_dashboard/features/auth/auth_router.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_states.dart';
import 'package:financial_dashboard/features/cash_flow/cash_flow_router.dart';
import 'package:financial_dashboard/features/common/components/custom_scafford.dart';
import 'package:financial_dashboard/features/invoices/invoice_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRoouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Text("Not Found")));
  },
  initialLocation: '/create-invoice',
  redirect: (context, state) async {
    // Check is still login, if not, redirect to /auth

    final authCubit = context.read<AuthCubit>();

    if (authCubit.state is AuthInitial) {
      await authCubit.checkAuth();
    }
    final isLoggedIn = authCubit.isLoggedIn;

    if (!isLoggedIn) {
      return '/auth';
    }
    // Allow
    return null;
  },
  routes: [
    AuthPageRouter(path: '/auth').route,
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return CustomScafford(
          isCashFlowPage: state.fullPath == '/cash-flow',
          isInvoicesPage: state.fullPath == '/create-invoice',
          child: child,
        );
      },
      routes: [
        CashFlowPageRouter(
          navigatorKey: _shellNavigatorKey,
          paht: '/cash-flow',
        ).route,
        CreateInvoiceRouter(
          navigatorKey: _shellNavigatorKey,
          path: '/create-invoice',
        ).route,
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
