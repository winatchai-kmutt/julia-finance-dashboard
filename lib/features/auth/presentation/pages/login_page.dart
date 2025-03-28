import 'package:financial_dashboard/features/auth/presentation/components/auth_text_field.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTapRegister;
  const LoginPage({super.key, required this.onTapRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  // login button pressed
  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure that the email & pw field are no empty
    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      // display error if some fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      body: SafeArea(
        child: Center(
          child: CustomContainer(
            width: 400,
            height: 600,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 108),
                  const SizedBox(height: 48),
                  Text(
                    "Julia Corporation Finance Company",
                    style: TextStyle(
                      color: AppColors.tealDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // email textfield
                  AuthTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  // login button
                  AuthTextField(
                    controller: pwController,
                    hintText: "Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),
                  // not a member ? register now
                  CustomButton(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    color: AppColors.tealDark,
                    enableBorder: false,
                    onTap: login,
                    child: Text(
                      "Login",
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                          color: AppColors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTapRegister,
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: AppColors.tealDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
