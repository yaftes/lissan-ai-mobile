import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const GoogleButton({required this.onTap, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFC),
          border: BoxBorder.all(color: const Color(0xFF112D4F)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 30,
            ),
          ],
        ),
        child: Center(
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
                text,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xFF112D4F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
