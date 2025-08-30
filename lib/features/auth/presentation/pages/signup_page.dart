import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
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
  bool termsAccepted = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityDisconnected) {
              return Image.asset('assets/images/no_internet.png');
            } else if (connectivityState is ConnectivityConnected) {
              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, authState) {
                  if (authState is AuthenticatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup Successful')),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (authState is AuthErrorState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(authState.message)));
                  }
                },

                builder: (context, authState) {
                  if (authState is AuthLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Join the Adventure!',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Start your English mastery journey today',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: nameController,
                                  title: 'Full Name',
                                  icon: Icons.person,
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
                              Checkbox(
                                value: termsAccepted,
                                onChanged: (value) {
                                  setState(() {
                                    termsAccepted = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the Terms of Service ',
                                    style: TextStyle(fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: 'and Privacy Policy',
                                        style: TextStyle(
                                          color: Color(0xFF112D4F),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            onPressed: () {
                              if (!termsAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You must accept the terms and privacy policy',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            text: 'Create Account',
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Or',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          GoogleButton(
                            onTap: () {},
                            text: 'Continue With Google',
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/sign-in'),
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
