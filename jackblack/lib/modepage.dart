import 'package:flutter/material.dart';
import 'package:jackblack/game.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/widgets/custom_button.dart';

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
              "Select\nGame Mode",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [Shadow(offset: Offset(5, 5), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Play Against Dealer",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
              },
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Host Game",
              width: 302,
              onPressed: () {
                // To host game screen
              },
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Join Game",
              width: 302,
              onPressed: () {
                // To join game screen
              },
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Back",
              width: 302,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TitlePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}