import 'package:flutter/material.dart';

class PlayingCard {
  // HRT, DMD, CLB, SPD
  final suit;
  // A, 2, 3, 4, 5, 6, 7, 8, 9, J, Q, K
  final rank;
  // May not need value
  final value;
  final String asset;

  PlayingCard({
    required this.suit,
    required this.rank,
    // May not need value, use set value function to switch between 1 and 11 for ace?
    // May not need because we'll have a function in player hand to calculate value
    this.value,
    String? asset,
  }) : asset = asset ?? 'assets/cards/$suit$rank.png';
}

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;

  PlayingCardWidget({
    required this.card
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(card.asset, width: 120, fit: BoxFit.cover);
  }
}