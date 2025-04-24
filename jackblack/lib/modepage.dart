import 'package:flutter/material.dart';
import 'package:jackblack/game.dart';

void main() {
  runApp(const MaterialApp(home: ModePage()));
}

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Game Mode",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
              ),
            ),
            const SizedBox(height: 40),
            buildModeButton(
              context,
              label: "Play Against Dealer",
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => GamePage()));
              },
            ),
            const SizedBox(height: 30),
            buildModeButton(
              context,
              label: "Join a Game with Virtual Cards",
              onPressed: () {},
            ),
            const SizedBox(height: 30),
            buildModeButton(
              context,
              label: "Join a Game with Physical Cards",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModeButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(198, 255, 202, 1),
          foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Minecraft'),
          ),
        ),
      ),
    );
  }
}