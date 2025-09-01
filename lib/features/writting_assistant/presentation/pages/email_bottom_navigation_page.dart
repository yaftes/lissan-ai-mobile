import 'package:flutter/material.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_draft_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/email_improve_page.dart';

class EmailBottomNavigationPage extends StatefulWidget {
  const EmailBottomNavigationPage({super.key});

  @override
  State<EmailBottomNavigationPage> createState() =>
      _EmailBottomNavigationPageState();
}

class _EmailBottomNavigationPageState extends State<EmailBottomNavigationPage> {
  int _selectedIndex = 0;

  // Pages and their AppBar titles
  final List<Widget> _pages = [const EmailDraftPage(), const EmailImprovePage()];

  final List<String> _pageTitles = [
    '📧 Email Writing Assistant',
    '⚡ Improve Emails',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        // backgroundColor: const Color(0xff112d4f), // Indigo
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // This Expanded widget pushes the title to the center
            Expanded(
              child: Text(
                _pageTitles[_selectedIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            // Logo on the left
            Image.asset(
              'assets/images/avatar.png', 
              height: 45,                       // adjust size as needed
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3F51B5),
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Draft'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Improve'),
        ],
      ),
    );
  }
}
