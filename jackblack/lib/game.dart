import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: StartPage()));
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<String> _deck = [];
  final List<String> _playerHand = [];
  final List<String> _dealerHand = [];

  String _gameMessage = "Welcome to Jack Black Blackjack!";
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _deck.clear();
    _playerHand.clear();
    _dealerHand.clear();
    _isGameOver = false;
    _gameMessage = "Game started!";

    const suits = ['♠', '♥', '♦', '♣'];
    const ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
      'A',
    ];

    for (var suit in suits) {
      for (var rank in ranks) {
        _deck.add('$rank$suit');
      }
    }

    _deck.shuffle(Random());

    _playerHand.add(_drawCard());
    _playerHand.add(_drawCard());
    _dealerHand.add(_drawCard());
    _dealerHand.add(_drawCard());

    setState(() {});
  }

  String _drawCard() => _deck.removeLast();

  int _calculateScore(List<String> hand) {
    int score = 0;
    int aceCount = 0;

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1);
      if (rank == 'A') {
        aceCount++;
        score += 11;
      } else if (['K', 'Q', 'J'].contains(rank)) {
        score += 10;
      } else {
        score += int.parse(rank);
      }
    }

    while (score > 21 && aceCount > 0) {
      score -= 10;
      aceCount--;
    }

    return score;
  }

  void _hit() {
    if (_isGameOver) return;
    _playerHand.add(_drawCard());

    int playerScore = _calculateScore(_playerHand);
    if (playerScore > 21) {
      _gameMessage = "You busted with $playerScore! Dealer wins.";
      _isGameOver = true;
    }

    setState(() {});
  }

  void _stand() {
    if (_isGameOver) return;

    while (_calculateScore(_dealerHand) < 17) {
      _dealerHand.add(_drawCard());
    }

    int playerScore = _calculateScore(_playerHand);
    int dealerScore = _calculateScore(_dealerHand);

    if (dealerScore > 21 || playerScore > dealerScore) {
      _gameMessage = "You win! $playerScore vs $dealerScore";
    } else if (playerScore < dealerScore) {
      _gameMessage = "Dealer wins! $dealerScore vs $playerScore";
    } else {
      _gameMessage = "It's a tie! $playerScore vs $dealerScore";
    }

    _isGameOver = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Jack Black Blackjack",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                "Dealer: ${_dealerHand.join(', ')}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Player: ${_playerHand.join(', ')}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                _gameMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isGameOver ? null : _hit,
                    child: const Text("Hit"),
                  ),
                  ElevatedButton(
                    onPressed: _isGameOver ? null : _stand,
                    child: const Text("Stand"),
                  ),
                  ElevatedButton(
                    onPressed: _startNewGame,
                    child: const Text("New Game"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
