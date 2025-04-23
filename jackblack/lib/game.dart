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
  final Player player = Player(name: "Player", funds: 1000.0);
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
      dealer.clear();
      player.addEmptyHand();
      curHandIndex = 0;
      isPlayerTurn = true;
      _gameMessage = "Welcome! Please make a bet to start";   
      _firstDeal();   
    });
  }

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _firstDeal(){
    setState(() {
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
        player.funds+=(curHand.bet * 3/2);
      }
    });
  }

  void _bet(double amount){
    setState(() {
      player.bet(curHand, amount);
    });
  }

  void _checkBust(){
    setState(() {
      int playerScore = curHand.sum;
      int dealerScore = dealer.sum;
      if (dealerScore > 21 || playerScore > dealerScore) {
          _gameMessage = "You win! $playerScore vs $dealerScore";
          player.funds+=2*curHand.bet;
        }
        else if (playerScore < dealerScore) {
          _gameMessage = "Dealer wins! $dealerScore vs $playerScore";
        }
        else {
          _gameMessage = "It's a tie! $playerScore vs $dealerScore";
          player.funds+=curHand.bet;
        }
    });
  }

  void _hit() {
    setState(() {
      player.hit(curHand, shoe);

      int playerScore = curHand.sum;
      if (playerScore > 21) {
        _gameMessage = "You busted with $playerScore! Dealer wins.";
        nextHand();
      }
    });
  }

  void _stand() {
    setState(() {
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }
      _checkBust();
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
    setState(() {
      int dealerLength = dealer.hand.length;
      if(dealerLength == 1){
        String dealerSuit = dealer.hand[0].suit;
        if (dealerSuit == "A") {
          player.insurance(curHand);
        }
      }
    });
  }

  // Check this with new card class value parameter
  void _split() {
    setState(() {
      int handLength = curHand.hand.length;
      if(handLength==2) {
        int c1 = curHand.hand[0].value;
        int c2 = curHand.hand[1].value;
        if(c1 == c2) {
          player.split(curHand);
          _gameMessage = "You split the hand, play your first hand first";
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/logo.PNG', scale: 2.5),
                        Text(
                          "Dealer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: (curHand.bet>0) ? dealer.hand.map((card) => PlayingCardWidget(card: card)).toList() : [],
                        ),
                        Text(
                          "Player",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: (curHand.bet>0) ? curHand.hand.map((card) => PlayingCardWidget(card: card)).toList() : [],
                        ),
                        Text(
                          _gameMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Minecraft',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (var value in [1, 5, 10, 25, 50, 100])
                              ElevatedButton(
                                onPressed: () => _bet(value.toDouble()),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                                ),
                                child: Text("\$$value"),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Sum: ${curHand.sum}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Minecraft',
                                ),
                              ),
                              Text(
                                "Bet: ${curHand.bet}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Minecraft',
                                ),
                              ),
                              Text(
                                "Funds: ${player.funds}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Minecraft',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 126, 75, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _hit : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Hit"),
                  ),
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _stand : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Stand"),
                  ),
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _surrender : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Surrender"),
                  ),
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _doubleDown : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Double Down"),
                  ),
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _insurance : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Insurance"),
                  ),
                  ElevatedButton(
                    onPressed: (isPlayerTurn && curHand.bet>0) ? _split : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("Split"),
                  ),
                  ElevatedButton(
                    onPressed: _startNewGame,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 14, fontFamily: 'Minecraft'),
                    ),
                    child: const Text("New Game"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
