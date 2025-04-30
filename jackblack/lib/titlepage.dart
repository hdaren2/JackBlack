import 'package:flutter/material.dart';
import 'package:jackblack/gameplay_instructions.dart';
import 'package:jackblack/widgets/custom_button.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Jack Black Blackjack",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(5, 5),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Start Game",
              onPressed: () {
                Navigator.pushReplacementNamed(context, "mode");
              },
            ),
            const SizedBox(height: 30),
             CustomButton(
              text: "How to Play",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GameplayInstructions()));
              },
            ),
          ],
        ),
      ),
    );
  }
}