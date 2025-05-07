import 'package:flutter/material.dart';
import 'package:jackblack/titlepage.dart'; // make sure this path is correct

class GameplayInstructions extends StatelessWidget {
  const GameplayInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  Text(
                    'How to Play Blackjack',
                    style: TextStyle(
                      fontFamily: 'Minecraft',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '- The goal of Blackjack is to beat the dealer\'s hand without going over 21.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Kings, Queens, and Jokers are worth 10 points. Aces are worth 1 or 11 points, whichever is better for the player.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Each player and the dealer starts with two cards. The dealer will have one card face up and one card face down.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- On your turn, you can choose to "Hit" (take another card) or "Stand" (keep your current hand).',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- If your hand exceeds 21, you "Bust" and lose the round.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- The dealer must hit until their cards total 17 or higher.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- If you beat the dealer\'s hand without busting, you win the round.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- If you and the dealer have the same hand, it\'s a "Push" and no one wins the round.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- If you run out of chips, you lose the game.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Surrendering allows the player to forfeit theird hand and recieve half their bet back instead of losing the full amount',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Splitting allows the player to split their hand into two hands if they have two cards of the same value.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'How Betting works',
                    style: TextStyle(
                      fontFamily: 'Minecraft',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Players start with a chip that represents how much money they have',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Before the start of the game, each player must bet their chips. Bets cannot fall below the minimum betting limit or go above the maximum betting limit.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Players can choose to double their bet after receiving their first two cards.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- In the instance that a player doubles their bet, they will only receive one additional card.',
                    style: _textStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Insurance is a side bet that the dealer has a blackjack. It is offered when the dealer\'s upcard is an Ace.',
                    style: _textStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TitlePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(198, 255, 202, 1),
                  foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  "Back to Title",
                  style: TextStyle(fontFamily: 'Minecraft'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

const TextStyle _textStyle = TextStyle(
  fontSize: 16,
  fontFamily: 'Minecraft',
  color: Colors.white,
);
