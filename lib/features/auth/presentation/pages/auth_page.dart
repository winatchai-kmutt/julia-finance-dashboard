import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_states.dart';
import 'package:financial_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:financial_dashboard/features/auth/presentation/pages/register_page.dart';
import 'package:financial_dashboard/features/common/components/custom_circular_progress_indicator.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially, show login page
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      // listen for errors...
      listener: (BuildContext context, AuthState state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        // authenticated -> home page
        if (state is Authenticated) {
          if (mounted) {
            context.go('/create-invoice');
          }
        }
      },

      builder: (context, state) {
        // unauthenticated -> auth page(login/register)
        if (state is Unauthenticated) {
          if (showLoginPage) {
            return LoginPage(onTapRegister: togglePages);
          } else {
            return RegisterPage(onTapLogin: togglePages);
          }
        }
        // loading...
        else {
          return const Scaffold(
            backgroundColor: AppColors.greyLight,
            body: Center(child: CustomCircularProgressIndicator()),
          );
        }
      },
    );
  }
}
