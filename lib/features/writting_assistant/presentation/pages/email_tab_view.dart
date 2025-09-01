import 'package:flutter/material.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_draft_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_improve_page.dart';

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
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleSpacing: 16,
          title: const Text(
            'Email Assistant',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          bottom: TabBar(
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
