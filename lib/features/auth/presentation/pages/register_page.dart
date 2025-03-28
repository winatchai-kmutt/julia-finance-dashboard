import 'package:financial_dashboard/features/auth/presentation/components/auth_text_field.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTapLogin;
  const RegisterPage({super.key, required this.onTapLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = pwConfirmController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    if (pw != confirmPw) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }
    // ensure the fiels aren't empty
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      authCubit.register(name, email, pw);
    } else {
      const SnackBar(content: Text("Please complete all fiels"));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    pwConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      body: SafeArea(
        child: Center(
          child: CustomContainer(
            width: 400,
            height: 700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 108),
                  const SizedBox(height: 48),
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: AppColors.tealDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // name textfield
                  AuthTextField(
                    controller: nameController,
                    hintText: "Name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: pwConfirmController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),
                  // not a member ? register now
                  CustomButton(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    color: AppColors.tealDark,
                    enableBorder: false,
                    onTap: register,
                    child: Text(
                      "Register",
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        "Alrady a member?",
                        style: TextStyle(color: AppColors.black),
                      ),
                      GestureDetector(
                        onTap: widget.onTapLogin,
                        child: Text(
                          "Login now",
                          style: TextStyle(color: AppColors.tealDark),
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
