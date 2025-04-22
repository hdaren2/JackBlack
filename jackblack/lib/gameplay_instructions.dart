import 'package:flutter/material.dart';

class GameplayInstructions extends StatelessWidget {
  const GameplayInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play Blackjack',
            style: TextStyle(fontFamily: 'Minecraft')
            ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'How to Play Blackjack',
              style: TextStyle(
                fontFamily: 'Minecraft',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. The goal of Blackjack is to beat the dealer\'s hand without going over 21.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '2. Face cards (Kings, Queens, and Jacks) are worth 10 points. Aces are worth 1 or 11 points, whichever makes a better hand.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '3. Each player starts with two cards, and the dealer also gets two cards, with one card face up and one face down.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '4. On your turn, you can choose to "Hit" (take another card) or "Stand" (keep your current hand).',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '5. If your hand exceeds 21, you "Bust" and lose the round.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '6. The dealer must hit until their cards total 17 or higher.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '7. If you beat the dealer\'s hand without busting, you win!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
          ],
        ),
      ),
    );
  }
}