import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_button.dart';
import 'package:lissan_ai/features/auth/presentation/widgets/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityDisconnected) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: Color(0xFF112D4F), size: 180),
                    SizedBox(height: 10),
                    Text(
                      'Please check your internet connection',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }

            return BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is AuthenticatedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Successful')),
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (authState is AuthErrorState) {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 50),
                          const SizedBox(height: 12),
                          Text(
                            'Login Failed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            authState.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF112D4F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              builder: (context, authState) {
                final isLoading = authState is AuthLoadingState;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF112D4F),
                          ),
                        ),
                        const SizedBox(height: 40),
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
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: passwordController,
                                title: 'Password',
                                icon: Icons.lock,
                                hintText: 'Password',
                                obscure: !isPasswordVisible,
                                enabled: !isLoading,
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
                                Checkbox(
                                  value: false,
                                  onChanged: isLoading ? null : (v) {},
                                ),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      final email = emailController.text.trim();
                                      final password = passwordController.text
                                          .trim();
                                      context.read<AuthBloc>().add(
                                        SignInEvent(
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF112D4F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(fontSize: 16),
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
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/sign-up'),
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
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
