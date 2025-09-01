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
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is ConnectivityConnected) {
              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, authState) {
                  if (authState is AuthenticatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Successful')),
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
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF112D4F),
                            ),
                          ),
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
                          CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                context.read<AuthBloc>().add(
                                  SignInEvent(email: email, password: password),
                                );
                              }
                            },
                            text: 'Sign In',
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
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Or continue with Google',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          GoogleButton(
                            onTap: () {},
                            text: 'Sign In With Google',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ConnectivityDisconnected) {
              return Image.asset('assets/images/no_internet.png');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
