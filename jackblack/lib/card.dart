import 'package:flutter/material.dart';

class PlayingCard {
  // HRT, DMD, CLB, SPD
  final String suit;
  // A, 2, 3, 4, 5, 6, 7, 8, 9, J, Q, K
  final String rank;
  // May not need value
  //final value;
  final String asset;

  PlayingCard({
    required this.suit,
    required this.rank,
    // May not need value, use set value function to switch between 1 and 11 for ace?
    // May not need because we'll have a function in player hand to calculate value
    //this.value,
    String? asset,
  }) : asset = asset ?? 'assets/cards/$suit$rank.png';

  int get value {
    if (rank == 'A') 
      return 11;
    if (['K', 'Q', 'J'].contains(rank)) 
      return 10;
    return int.parse(rank);
  }
}

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final double width;

  PlayingCardWidget({
    required this.card,
    this.width = 120
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(card.asset, width: width, fit: BoxFit.cover);
  }
}