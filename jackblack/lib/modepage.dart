import 'package:flutter/material.dart';

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Play Against Bots"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              // Fix up these confusing names later
              child: Text("Join a Game with Cards"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              // Fix up these confusing names later
              child: Text("Join a Game without Cards"),
            ),
          ],
        ),
      ),
    );
  }
}