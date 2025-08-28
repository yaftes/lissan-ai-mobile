import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_button.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/google_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Join the Adventure !',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  'start your English mastery journey today',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF112D4F),
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),

                Text(
                  'join 100+ learners already winning',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),

                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: nameController,
                        title: 'Full Name',
                        icon: Icons.password,
                        hintText: 'Your Full Name',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: emailController,
                        title: 'Email Address',
                        icon: Icons.email,
                        hintText: 'your.email@example.com',
                      ),

                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: passwordController,
                        title: 'Password',
                        icon: Icons.password,
                        hintText: 'Create a strong password',
                        obscure: true,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: confirmPasswordController,
                        title: 'Confirm Password',
                        icon: Icons.password,
                        hintText: 'Confirm your password',
                        obscure: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(value: false, onChanged: (value) {}),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree the Terms of Service ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'and Privacy Policy',
                              style: TextStyle(color: Color(0xFF112D4F)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomButton(onPressed: () {}, text: 'Create Account'),

                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                GoogleButton(onTap: () {}, text: 'Continue With Google'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account ?'),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/sign-in'),
                      child: Text(
                        'Sign in',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF112D4F),
                          fontSize: 16,
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
    );
  }
}
