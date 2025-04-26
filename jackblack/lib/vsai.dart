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
  final List<Player> aiPlayers = [
    Player(name: "AI 1", funds: 1000.0),
    Player(name: "AI 2", funds: 1000.0),
    Player(name: "AI 3", funds: 1000.0),
  ];
  final List<Hand> aiHands = [];
  bool isPlayerTurn = true;
  int curHandIndex = 0;
  bool hasBet = false;
  bool isGameEnding = false;
  bool isTransitioning = false;
  bool showDealerCard = false;

  String _gameMessage = "Welcome to Jack Black Blackjack!";

  Hand get curHand => player.hands[curHandIndex];

  void nextHand() {
    setState(() {
      if (curHandIndex + 1 < player.hands.length) {
        curHandIndex++;
      } else {
        isPlayerTurn = false;
        _dealerPlay();
      }
    });
  }

  void _playAiTurns() {
    for (int i = 0; i < aiPlayers.length; i++) {
      final ai = aiPlayers[i];
      final hand = aiHands[i];

      while (hand.sum < 17) {
        ai.hit(hand, shoe);
      }
    }
  }

  void _dealerPlay() {
    setState(() {
      showDealerCard = true;
      _playAiTurns();
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }
      _checkBust();
    });
  }

  double bet(Player p, Hand h, double amount) {
    p.funds -= amount;
    return amount;
  }

  void _startNewGame() {
    setState(() {
      // Reset everything
      player.hands.clear();
      dealer.clear();
      player.addEmptyHand();
      curHandIndex = 0;
      isPlayerTurn = true;
      hasBet = false;
      isGameEnding = false;
      isTransitioning = false;
      showDealerCard = false;
      _gameMessage = "Welcome! Please make a bet to start";
      aiHands.clear();
      for (var ai in aiPlayers) {
        ai.hands.clear();
        ai.addEmptyHand();
        aiHands.add(ai.hands.first);
      }
    });
  }

  void _showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Leave Game?',
            style: TextStyle(fontFamily: 'Minecraft', color: Colors.red),
          ),
          content: Text(
            'Are you sure you want to leave the game and forfeit the current round?',
            style: TextStyle(fontFamily: 'Minecraft'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'No',
                style: TextStyle(fontFamily: 'Minecraft', color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _endGame();
              },
              child: Text(
                'Yes',
                style: TextStyle(fontFamily: 'Minecraft', color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _endGame() {
    setState(() {
      isGameEnding = true;
      isTransitioning = true;
      _gameMessage = "Game ended. Returning to main menu...";
      // Add a delay before returning to main menu
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "title");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _firstDeal() {
    setState(() {
      // Deal two cards to player
      curHand.add(shoe.deal());
      curHand.add(shoe.deal());
      // Deal two cards to dealer
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      // Deal two cards to each AI player
      for (var hand in aiHands) {
        hand.add(shoe.deal());
        hand.add(shoe.deal());
      }
      // Check for immediate blackjack
      if (curHand.sum == 21) {
        _gameMessage = "Blackjack! You win.";
        isPlayerTurn = false;
        player.funds += (curHand.bet * 3 / 2);
        // Add delay before next game
        isTransitioning = true;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _startNewGame();
          });
        });
      }
    });
  }

  void _bet(double amount) {
    setState(() {
      if (player.funds >= amount) {
        player.bet(curHand, amount);
        _gameMessage = "Game in progress";
        for (int i = 0; i < aiPlayers.length; i++) {
          if (aiPlayers[i].funds >= amount) {
            aiPlayers[i].bet(aiHands[i], amount);
          }
        }
      } else {
        _gameMessage = "You don't have enough funds for that bet!";
      }
    });
  }

  void _placeBet() {
    setState(() {
      hasBet = true;
      _firstDeal();
    });
  }

  void _checkBust() {
    setState(() {
      int playerScore = curHand.sum;
      int dealerScore = dealer.sum;

      if (playerScore > 21 && dealerScore > 21) {
        _gameMessage = "You both bust! $playerScore vs $dealerScore";
      } else if (playerScore > 21) {
        _gameMessage = "You busted with $playerScore! Dealer wins.";
      } else if (dealerScore > 21) {
        _gameMessage = "Dealer busted with $dealerScore! You win!";
        player.funds += 2 * curHand.bet;
      } else if (playerScore > dealerScore) {
        _gameMessage = "You win! $playerScore vs $dealerScore";
        player.funds += 2 * curHand.bet;
      } else if (playerScore < dealerScore) {
        _gameMessage = "Dealer wins! $dealerScore vs $playerScore";
      } else {
        _gameMessage = "It's a tie! $playerScore vs $playerScore";
        player.funds += curHand.bet;
      }

      // Add delay before next game
      isTransitioning = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _startNewGame();
        });
      });
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
    nextHand();
  }

  void _surrender() {
    // Discard bet and hand
    nextHand();
  }

  void _doubleDown() {
    setState(() {
      if (curHand.sum <= 11) player.doubleDown(curHand);
    });
    // Check sum
    nextHand();
  }

  void _insurance() {
    setState(() {
      int dealerLength = dealer.hand.length;
      if (dealerLength == 1) {
        String dealerSuit = dealer.hand[0].suit;
        if (dealerSuit == "A") {
          player.insurance(curHand);
        }
      }
    });
  }

  void _split() {
    setState(() {
      int handLength = curHand.hand.length;
      if (handLength == 2) {
        int c1 = curHand.hand[0].value;
        int c2 = curHand.hand[1].value;
        if (c1 == c2) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
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
                          children:
                              (curHand.bet > 0)
                                  ? [
                                    if (dealer.hand.isNotEmpty)
                                      SizedBox(
                                        width:
                                            dealer.hand.length >= 4 ? 85 : 120,
                                        child: PlayingCardWidget(
                                          card: dealer.hand[0],
                                        ),
                                      ),
                                    if (dealer.hand.length > 1)
                                      SizedBox(
                                        width:
                                            dealer.hand.length >= 4 ? 85 : 120,
                                        child:
                                            showDealerCard
                                                ? PlayingCardWidget(
                                                  card: dealer.hand[1],
                                                )
                                                : SizedBox(
                                                  width:
                                                      dealer.hand.length >= 4
                                                          ? 85
                                                          : 120,
                                                  height: 182,
                                                  child: Image.asset(
                                                    'assets/cards/CARDBACK.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                      ),
                                    ...dealer.hand
                                        .skip(2)
                                        .map(
                                          (card) => SizedBox(
                                            width:
                                                dealer.hand.length >= 4
                                                    ? 85
                                                    : 120,
                                            child: PlayingCardWidget(
                                              card: card,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ]
                                  : [],
                        ),
                        SizedBox(height: 30),
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
                          children:
                              (curHand.bet > 0)
                                  ? curHand.hand
                                      .map(
                                        (card) => SizedBox(
                                          width:
                                              curHand.hand.length >= 4
                                                  ? 85
                                                  : 120,
                                          child: PlayingCardWidget(card: card),
                                        ),
                                      )
                                      .toList()
                                  : [],
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
                        if (isTransitioning && !isGameEnding)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Loading next game...",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Minecraft',
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (!hasBet)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (var value in [1, 5, 10, 25, 50, 100])
                                ElevatedButton(
                                  onPressed: () => _bet(value.toDouble()),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Minecraft',
                                    ),
                                  ),
                                  child: Text("\$$value"),
                                ),
                              ElevatedButton(
                                onPressed: _placeBet,
                                child: const Text("Place Bet"),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (hasBet)
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
            if ((hasBet && !isTransitioning) || (!hasBet && !isTransitioning))
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
                    if (hasBet && !isTransitioning) ...[
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0) ? _hit : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Hit"),
                      ),
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0) ? _stand : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Stand"),
                      ),
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0)
                                ? _surrender
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Surrender"),
                      ),
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0)
                                ? _doubleDown
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Double Down"),
                      ),
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0)
                                ? _insurance
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Insurance"),
                      ),
                      ElevatedButton(
                        onPressed:
                            (isPlayerTurn && curHand.bet > 0) ? _split : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Split"),
                      ),
                    ],
                    if (!isTransitioning)
                      ElevatedButton(
                        onPressed: _showLeaveConfirmation,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Minecraft',
                          ),
                        ),
                        child: const Text("Leave Game"),
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
