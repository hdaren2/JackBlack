import 'dart:math';
import 'package:jackblack/card.dart';

class Shoe {
  final List<PlayingCard> _decks = [];

  final suits = ["HRT", "DMD", "CLB", "SPD"];
  final ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"};

  // Creates shoe with n decks all shuffled
  Shoe(int numDecks) {
    for (int i = 0; i < numDecks; i++) {
      for (var suit in suits) {
        for (var rank in ranks) {
          _decks.add(PlayingCard(suit: suit, rank: rank));
        }
      }
    }
    shuffle();
  }

  void shuffle(){
    _decks.shuffle(Random());
  }

  PlayingCard deal(){
    return _decks.removeLast();
  }
}