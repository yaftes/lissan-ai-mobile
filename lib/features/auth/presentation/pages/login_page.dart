import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Image.asset('assets/images/celebrate.jpg'),
                        ),
                      ],
                    ),
                    Text(
                      'Ready to continue your English journey?',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sign in',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF08CC2F),
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continue your path to English mastery!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(width: 3),
                        SizedBox(
                          height: 30,
                          width: 20,
                          child: Transform.rotate(
                            angle: 22.92 * math.pi / 180,
                            child: Image.asset('assets/images/rocket.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCFC),
                          border: BoxBorder.all(color: const Color(0xFF92FFB3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/images/google.png'),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Sign In with Google',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF08B129),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Or continue with email',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            controller: emailController,
                            title: 'Email Address',
                            icon: Icons.email,
                            labelText: 'Email',
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: passwordController,
                            title: 'Password',
                            icon: Icons.password,
                            labelText: 'password',
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
                            color: const Color(0xFF08B129),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6BDB54),
                            Color(0xFF38A0AB),
                            Color(0xFF1848F4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        Text(
                          'Create Account',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF08B129),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(Colors.green, 'Secure Login'),
                  const SizedBox(width: 10),
                  _buildCard(Colors.blue, 'Fast Access'),
                  const SizedBox(width: 10),
                  _buildCard(Colors.deepPurpleAccent, 'Always Available'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.inter(fontSize: 13)),
      ],
    );
  }
}
