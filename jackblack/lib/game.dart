import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Shoe shoe = Shoe(6);
  final Player player = Player(name: "Player", funds: 1000);
  final DealerHand dealer = DealerHand();
  bool isPlayerTurn = true;
  int curHandIndex = 0;

  String _gameMessage = "Welcome to Jack Black Blackjack!";

  Hand get curHand => player.hands[curHandIndex];

  void nextHand() {
    setState(() {
      if (curHandIndex + 1 < player.hands.length) {
        curHandIndex++;
      } else {
        isPlayerTurn = false;
      }
    });
  }

  double bet(Player p, Hand h, double amount) {
    p.funds-=amount;
    return amount;
  }

  // Need to reorganize this
  void _startNewGame() {
    setState(() {
      // Reset everything
      player.hands.clear();
      curHandIndex = 0;
      isPlayerTurn = true;
      dealer.clear();
      _gameMessage = "Game Started";
      // Add a new empty hand to start with
      player.hands.add(Hand());
      // Deal two cards to player
      curHand.add(shoe.deal());
      curHand.add(shoe.deal());
      // Deal two cards to dealer
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      // Check for immediate blackjack
      if (curHand.sum == 21) {
        _gameMessage = "Blackjack! You win.";
        isPlayerTurn = false;
        // Handle payout, etc.
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }


  void _hit() {
    setState(() {
      player.hit(curHand, shoe);

      int playerScore = curHand.sum;
      if (playerScore > 21) {
        _gameMessage = "You busted with $playerScore! Dealer wins.";
      }
    });
  }

  void _stand() {
    setState(() {
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }

      int playerScore = curHand.sum;
      int dealerScore = dealer.sum;

      if (dealerScore > 21 || playerScore > dealerScore) {
        _gameMessage = "You win! $playerScore vs $dealerScore";
        // Award winnings
      }
      else if (playerScore < dealerScore) {
        _gameMessage = "Dealer wins! $dealerScore vs $playerScore";
      }
      else {
        _gameMessage = "It's a tie! $playerScore vs $dealerScore";
      }
      nextHand();
    });
  }

  void _surrender(){
    // Discard bet and hand
    nextHand();
  }

  void _doubleDown(){
    setState(() {
      if(curHand.sum <= 11)
        player.doubleDown(curHand);
    });
    // Check sum
    nextHand();
  }

  void _insurance(){
    int dealerLength = dealer.hand.length;
    if(dealerLength == 1){
      String dealerSuit = dealer.hand[0].suit;
      if (dealerSuit == "A") {
        player.insurance(curHand);
      }
    }
  }

  // Check this with new card class value parameter
  void _split() {
    int handLength = curHand.hand.length;
    if(handLength==2) {
      int c1 = curHand.hand[0].value;
      int c2 = curHand.hand[1].value;
      if(c1 == c2) {
        player.split(curHand);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/logo.PNG', scale: 2),
              Text(
                "Dealer"
              ),
              Wrap(
                spacing: 8,
                children: dealer.hand.map((card) => PlayingCardWidget(card: card)).toList(),
              ),
              Text(
                "Player"
              ),
              Wrap(
                spacing: 8,
                children: curHand.hand.map((card) => PlayingCardWidget(card: card)).toList(),
              ),
              Text(
                _gameMessage,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isPlayerTurn ?_hit : null,
                    child: const Text("Hit"),
                  ),
                  ElevatedButton(
                    onPressed: isPlayerTurn ? _stand : null,
                    child: const Text("Stand"),
                  ),
                  ElevatedButton(
                    onPressed: isPlayerTurn ? _surrender : null,
                    child: const Text("Surrender"),
                  ),
                  ElevatedButton(
                    onPressed: isPlayerTurn ? _doubleDown : null,
                    child: const Text("Double Down"),
                  ),
                  ElevatedButton(
                    onPressed: isPlayerTurn ? _insurance : null,
                    child: const Text("Insurance"),
                  ),
                  ElevatedButton(
                    onPressed: isPlayerTurn ? _split : null,
                    child: const Text("Split"),
                  ),
                  ElevatedButton(
                    onPressed: _startNewGame,
                    child: const Text("New Game"),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
