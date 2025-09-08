import 'package:flutter/material.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_draft_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_improve_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/saved_emails_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/saved_email_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/injection_container.dart';

class EmailTabView extends StatefulWidget {
  const EmailTabView({super.key});

  @override
  State<EmailTabView> createState() => _EmailTabViewState();
}

class _EmailTabViewState extends State<EmailTabView> {
  final List<Widget> _pages = const [EmailDraftPage(), EmailImprovePage()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: TabBar(
            indicatorColor: const Color(0xFF112D4F),
            labelColor: const Color(0xFF112D4F),
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.drafts), text: 'Draft'),
              Tab(icon: Icon(Icons.update), text: 'Improve'),
            ],
          ),
          actions: [
            Tooltip(
              message: 'Saved',
              child: IconButton(
                icon: const Icon(Icons.bookmark, color: Color(0xFF112D4F)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (_) => getIt<SavedEmailBloc>(),
                        child: const SavedEmailsPage(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

        ),
        body: TabBarView(
          children: _pages.map((page) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: page,
            );
          }).toList(),
        ),
      ),
    );
  }
}
