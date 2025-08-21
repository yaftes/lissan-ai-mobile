import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Text(
              'Continue your path to English mastery!',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          ],
        ),
      ),
    );
  }
}
