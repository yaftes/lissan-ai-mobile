import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';

class AuthWrapperPage extends StatefulWidget {
  const AuthWrapperPage({super.key});
  @override
  State<AuthWrapperPage> createState() => _AuthWrapperPageState();
}

class _AuthWrapperPageState extends State<AuthWrapperPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushNamed(context, '/home');
        } else if (state is UnAuthenticatedState) {
          Navigator.pushNamed(context, '/sign-in');
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const CircularProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
