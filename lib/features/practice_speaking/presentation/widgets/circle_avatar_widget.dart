import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final double radius;
  final double width;
  final double heigth;
  const CircleAvatarWidget({
    super.key,
    required this.radius,
    required this.width,
    required this.heigth,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.green,
      child: ClipOval(
        child: Image.asset(
          'assets/images/person.png',
          width: width,
          height: heigth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
