import 'dart:math';



class Card {
  String rank;
  String suit;

  Card({required this.rank, required this.suit});

  int get value {
    if (rank == 'A') return 11;
    if (['K', 'Q', 'J'].contains(rank)) return 10;
    return int.parse(rank);
  }
}

class Shoe{
  final List<Card> _decks = [];
  final Random _random = Random();

  //creates shoe with n decks all shuffled
  Shoe(int numDecks) {
    List<String> ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
    List<String> suits = ['♠', '♥', '♦', '♣'];

    for (int i = 0; i < numDecks; i++) {
      for (String suit in suits) {
        for (String rank in ranks) {
          _decks.add(Card(rank: rank, suit: suit));
        }
      }
    }
    _decks.shuffle(_random);
  }

  shuffleShoe(){
    _decks.shuffle(_random);
  }

  Card dealCard(){
    return _decks.removeLast();
  }
}