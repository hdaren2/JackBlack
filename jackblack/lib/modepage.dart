import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ModePage()));
}

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(89, 148, 87, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select Game Mode", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(198, 255, 202, 1),
                foregroundColor: Color.fromRGBO(0, 0, 0, 1),
              ),
              child: Text("Play Against Bots"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(198, 255, 202, 1),
                foregroundColor: Color.fromRGBO(0, 0, 0, 1),
              ),
              // Fix up these confusing names later
              child: Text("Join a Game with Virtual Cards"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(198, 255, 202, 1),
                foregroundColor: Color.fromRGBO(0, 0, 0, 1),
              ),
              // Fix up these confusing names later
              child: Text("Join a Game with Physical Cards"),
            ),
          ],
        ),
      ),
    );
  }
}