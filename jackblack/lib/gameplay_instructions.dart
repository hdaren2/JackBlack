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
              '- The goal of Blackjack is to beat the dealer\'s hand without going over 21.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- Kings, Queens, and Jokers are worth 10 points. Aces are worth 11 points.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- Each player and the dealer starts with two cards. The dealer will have one card face up and one card face down.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- On your turn, you can choose to "Hit" (take another card) or "Stand" (keep your current hand).',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- If your hand exceeds 21, you "Bust" and lose the round.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- The dealer must hit until their cards total 17 or higher.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- If you beat the dealer\'s hand without busting, you win the round.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- If you and the dealer have the same hand, it\'s a "Push" and no one wins the round.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- If you run out of chips, you lose the game.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 16),
            Text(
              'How Betting works',
              style: TextStyle(
                fontFamily: 'Minecraft',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Players start with a chip that represents how much money they have',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- Before the start of the game, each player must bet their chips. Bets cannot fall below the minimum betting limit or go above the maximum betting limit.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- Players can choose to double their bet after receiving their first two cards.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            ),
            SizedBox(height: 8),
            Text(
              '- In the instance that a player doubles their bet, they will only receive one additional card.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Minecraft',),
            )
          ],
        ),
      ),
    );
  }
}