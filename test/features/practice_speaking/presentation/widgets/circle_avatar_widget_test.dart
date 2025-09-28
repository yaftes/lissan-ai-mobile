import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/circle_avatar_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircleAvatarWidget Tests', () {
    testWidgets('renders with correct radius and padding', (WidgetTester tester) async {
      const radius = 120.0;
      const padd = 16.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatarWidget(radius: radius, padd: padd),
          ),
        ),
      );

      // Find the widget
      final circleAvatarFinder = find.byType(CircleAvatarWidget);
      expect(circleAvatarFinder, findsOneWidget);

      // Get the widget instance
      final circleAvatar = tester.widget<CircleAvatarWidget>(circleAvatarFinder);
      expect(circleAvatar.radius, equals(radius));
      expect(circleAvatar.padd, equals(padd));
    });

    testWidgets('displays an Image.asset inside ClipOval', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatarWidget(radius: 100, padd: 12),
          ),
        ),
      );

      // Verify ClipOval exists
      expect(find.byType(ClipOval), findsOneWidget);

      // Verify an Image widget is present
      expect(find.byType(Image), findsOneWidget);

      // Verify the image is from assets
      final imageWidget = tester.widget<Image>(find.byType(Image));
      final imageProvider = imageWidget.image as AssetImage;
      expect(imageProvider.assetName, 'assets/images/avatar.png');
    });
  });
}
