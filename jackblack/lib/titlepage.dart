import 'package:flutter/material.dart';

void main() {
  runApp(const TitlePage());
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Jack Black Blackjack"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "mode");
                },
                child: const Text("Start Game"),
              ),
            ],
        ))
      ),
    );
  }
}