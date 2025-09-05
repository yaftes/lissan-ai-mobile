import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/saved_email_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/saved_email_event.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/saved_email_state.dart';

class SavedEmailsPage extends StatefulWidget {
  const SavedEmailsPage({super.key});

  @override
  State<SavedEmailsPage> createState() => _SavedEmailsPageState();
}




class _SavedEmailsPageState extends State<SavedEmailsPage> {

  @override
  void initState() {
    super.initState();
    context.read<SavedEmailBloc>().add(LoadSavedEmailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Saved Emails',
          style: TextStyle(
            color: Color(0xFF112D4F),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF112D4F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
    );
  }


}
