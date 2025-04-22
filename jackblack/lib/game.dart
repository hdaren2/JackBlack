import 'dart:math';
import 'package:flutter/material.dart';
import 'player.dart';

void main() {
  runApp(const MaterialApp(home: StartPage()));
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final Shoe shoe = Shoe(6);
  final Player player = Player(name: "me", funds: 1000);
  final DealerHand dealer = DealerHand();
  bool isPlayerTurn = true;
  int currentHandIndex = 0;

  String _gameMessage = "Welcome to Jack Black Blackjack!";

  Hand get currentHand => player.hands[currentHandIndex];

  void nextHand() {
    setState(() {
    if (currentHandIndex + 1 < player.hands.length) {
      currentHandIndex++;
    } else {
      isPlayerTurn = false;
    }
  });
  }

  double bet(Player p,Hand h, double amount){
    p.funds-=amount;

    return amount;
  }

    //need to reorganize this
  void _startNewGame() {
    setState(() {
    // Reset everything
    player.hands.clear();
    currentHandIndex = 0;
    isPlayerTurn = true;
    dealer.clear();
    _gameMessage = "Game started";
    // Add a new empty hand to start with
    player.hands.add(Hand());
    // Deal two cards to player
    currentHand.add(shoe.dealCard());
    currentHand.add(shoe.dealCard());
    // Deal two cards to dealer
    dealer.add(shoe.dealCard());
    dealer.add(shoe.dealCard());
    // Check for immediate blackjack
    if (currentHand.sum() == 21) {
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
      player.hit(currentHand, shoe);

      int playerScore = currentHand.sum();
      if (playerScore > 21) {
        _gameMessage = "You busted with $playerScore! Dealer wins.";
      }
    });
  }

  void _stand() {
    setState(() {
      while (dealer.sum() < 17) {
        dealer.add(shoe.dealCard());
      }

      int playerScore = currentHand.sum();
      int dealerScore = dealer.sum();

      if (dealerScore > 21 || playerScore > dealerScore) {
        _gameMessage = "You win! $playerScore vs $dealerScore";
        //award winnings
      } else if (playerScore < dealerScore) {
        _gameMessage = "Dealer wins! $dealerScore vs $playerScore";

      } else {
        _gameMessage = "It's a tie! $playerScore vs $dealerScore";

      }

      nextHand();
    });
  }

  void _surrender(){
    //discard bet and hand
    nextHand();
  }

  void _doubleDown(){
    setState(() {
      if(currentHand.sum()<=11)
        player.doubleDown(currentHand);
    });
    //check sum
    nextHand();
  }

  void _insurance(){
    int dealerLength = dealer.hand.length;
    if(dealerLength==1){
      String dealerSuit = dealer.hand[0].suit;
      if(dealerSuit=="A")
        player.insurance(currentHand);
    }
  }

  void _split(){
    int handLength = currentHand.hand.length;
    if(handLength==2){
      int c1 = currentHand.hand[0].value;
      int c2 = currentHand.hand[1].value;
      if(c1==c2)
        player.split(currentHand);
    }
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
                "Dealer: ${dealer.toString()}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Player: ${currentHand.toString()}",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
