import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';

class AuthWrapperPage extends StatefulWidget {
  const AuthWrapperPage({super.key});

  @override
  State<AuthWrapperPage> createState() => _AuthWrapperPageState();
}

class _AuthWrapperPageState extends State<AuthWrapperPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        // TODO based on the state navigate or return the pages
      },
    );
  }
}
