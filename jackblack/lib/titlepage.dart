import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(89, 148, 87, 1), 
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
                  color: Colors.black,
                  fontFamily: 'Minecraft',
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "mode");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(198, 255, 202, 1), 
                  foregroundColor: const Color.fromRGBO(0, 0, 0, 1), 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Start Game", style: TextStyle(fontFamily: 'Minecraft')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
