import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BlackjackTablePainter(),
            ),
          ),
          // Add logo in the center
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// player positions and labels (can make this usernames later)
class BlackjackTablePainter extends CustomPainter {
  List<Map<String, dynamic>> _getPlayerPositions(Size size) {
    return [
      {'pos': Offset(size.width * 0.5, size.height * 0.35), 'isDealer': true},  // Center dealer spot
      {'pos': Offset(size.width * 0.5, size.height * 0.15)},  // Top
      {'pos': Offset(size.width * 0.85, size.height * 0.5)},  // Right
      {'pos': Offset(size.width * 0.5, size.height * 0.7), 'isUser': true},  // Bottom (User)
      {'pos': Offset(size.width * 0.15, size.height * 0.5)},  // Left
    ];
  }

  void _drawPlayerPositions(Canvas canvas, Size size, Paint cardAreaPaint, List<Map<String, dynamic>> playerPositions) {
    for (var player in playerPositions) {
      var position = player['pos'] as Offset;
      var isDealer = player['isDealer'] as bool? ?? false;
      var isUser = player['isUser'] as bool? ?? false;
      
      // Adjust size for dealer and user spots
      double width = size.width * (isDealer || isUser ? 0.2 : 0.15);
      double height = size.height * (isDealer || isUser ? 0.2 : 0.15);
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(position.dx, position.dy),
          width: width,
          height: height,
        ),
        cardAreaPaint,
      );
    }
  }

  // made the player labels in the minecraft font that was imported
  void _drawPlayerLabels(Canvas canvas, List<Map<String, dynamic>> playerPositions) {
    for (var player in playerPositions) {
      var position = player['pos'] as Offset;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: player['label'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Minecraft',
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(position.dx - 30, position.dy - 50),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final tablePaint = Paint()
      ..color = const Color(0xFF0F5132)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      tablePaint,
    );

    // made the border brown
    final borderPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    // made it shaped like a poker table
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.7)
      ..arcToPoint(
        Offset(size.width, size.height * 0.7),
        radius: Radius.circular(size.width * 0.8),
        clockwise: false,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, borderPaint);

    // Draw card placement areas with slight transparency
    final cardAreaPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Get player positions
    final playerPositions = _getPlayerPositions(size);

    // Draw player positions and labels
    _drawPlayerPositions(canvas, size, cardAreaPaint, playerPositions);
    _drawPlayerLabels(canvas, playerPositions);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 