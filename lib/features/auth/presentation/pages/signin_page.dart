import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signup_page.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_button.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/google_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                const Text('Login'),
                const SizedBox(height: 25),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: emailController,
                        title: 'Email Address',
                        icon: Icons.email,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: passwordController,
                        title: 'Password',
                        icon: Icons.password,
                        hintText: 'password',
                        obscure: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        const Text('Remember Me'),
                      ],
                    ),
                    Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF112D4F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                CustomButton(onPressed: () {}, text: 'Sign In'),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to LissanAI?',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/sign-up'),
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF112D4F),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or continue with Google',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 25),
                GoogleButton(onTap: () {}, text: 'Sign In With Google'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
