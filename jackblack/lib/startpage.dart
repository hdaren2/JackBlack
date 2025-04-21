import 'package:flutter/material.dart';
import 'modepage.dart';

void main() {
  runApp(const StartPageEntry());
}

class StartPageEntry extends StatelessWidget {
  const StartPageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Jack Black Blackjack"),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ModePage()),
                  );
                },
                child: const Text("Start Game"),
              ),
            ],
        ))
      ),
    );
  }
}