import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: _buildText('Lissan Ai'),
          onTap: (){
            
          },
        ),
        ListTile(
          title: _buildText('Mock Interviews'),
          onTap: (){

          },
        ),
        ListTile(
          title: _buildText('Grammer Coach'),
          onTap: (){

          },
        ),
        ListTile(
          title: _buildText('Learn'),
          onTap: (){

          },
        ),
        ListTile(
          title: _buildText('Email Drafting'),
          onTap: (){

          },
        ),
        ListTile(
          title: _buildText('Pronouncation'),
          onTap: (){

          },
        ),
      ],
    ),
  );
}

Widget _buildText(String text){
  return Center(
    child: Text(text, style: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black
    ),),
  );
}
}