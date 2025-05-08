import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/widgets/show_hands.dart';
import 'package:jackblack/blackjack.dart';

class MultiPlayer extends StatefulWidget {
  const MultiPlayer({super.key});

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> {
  final BlackJack _game = BlackJack(
    players: [
      Player(name: "p1", funds: 1000),
      Player(name: "p2", funds: 1000),
      Player(name: "p3", funds: 1000),
      Player(name: "p4", funds: 1000),
    ],
  );

  String? _lastPlayerName; // <-- Track previous player

  Player get curPlayer => _game.players[_game.curPlayerIndex];
  Hand get curHand => curPlayer.hands[_game.curHandIndex];

  void startGame() {
    setState(() {
      _game.startGame();
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void hit() {
    setState(() {
      _game.hit();
    });
  }

  void stand() {
    setState(() {
      _game.stand();
    });
  }

  void surrender() {
    setState(() {
      _game.surrender(curHand);
    });
  }

  void doubleDown() {
    setState(() {
      _game.doubleDown();
    });
  }

  void insurance() {
    setState(() {
      _game.insurance();
    });
  }

  void split() {
    setState(() {
      _game.split();
    });
  }

  void addToInitialBet(double amount) {
    setState(() {
      _game.addToInitialBet(curPlayer, amount);
    });
  }

  void subFromInitialBet(double amount) {
    setState(() {
      _game.subFromInitialBet(curPlayer, amount);
    });
  }

  void resetInitialBet() {
    setState(() {
      _game.resetInitialBet(curPlayer);
    });
  }

  void confirmInitialBet() {
    setState(() {
      _game.confirmInitialBet(curPlayer);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastPlayerName != curPlayer.name &&
          !_game.showBetPrompt &&
          !_game.roundOver) {
        _lastPlayerName = curPlayer.name;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${curPlayer.name}'s turn!",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green[700],
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 40),
              // Top section - First two player hands
              _buildTopPlayersSection(),

              // Middle section - Dealer
              _buildDealerSection(),

              // Bottom section - Last two player hands
              _buildBottomPlayersSection(),

              // Button controls
              _buildButtonSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPlayersSection() {
    if (_game.showBetPrompt) {
      return SizedBox(height: MediaQuery.of(context).size.height * 0.1);
    }
    final topPlayers =
        _game.players.length >= 2
            ? _game.players.sublist(0, min(2, _game.players.length))
            : _game.players;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...topPlayers.map(
                (player) => Expanded(child: PlayerHandDisplay(player: player)),
              ),
              if (topPlayers.length < 2) Expanded(child: Container()),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(topPlayers.length * 2 - 1, (index) {
                if (index % 2 == 0) {
                  final player = topPlayers[index ~/ 2];
                  return Expanded(
                    child: Text(
                      "Sum: ${player.hands[0].sum}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Minecraft',
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 0,
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(width: 12);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDealerSection() {
    if (_game.showBetPrompt) {
      // Temporary bet display
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${curPlayer.name}, make a bet to start:",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(3.9, 3.9),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                for (var value in [1, 5, 10])
                  CustomButton(
                    text: "\$$value",
                    onPressed: () {
                      addToInitialBet(value.toDouble());
                    },
                  ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                for (var value in [25, 50, 100])
                  CustomButton(
                    text: "\$$value",
                    onPressed: () {
                      addToInitialBet(value.toDouble());
                    },
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "\$${curPlayer.funds}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Minecraft',
                        shadows: [
                          Shadow(
                            offset: Offset(2.4, 2.4),
                            blurRadius: 0,
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  "Bet: \$${_game.initialBet}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Minecraft',
                    shadows: [
                      Shadow(
                        offset: Offset(2.9, 3.1),
                        blurRadius: 0,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Regular dealer section
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Dealer",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Minecraft',
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 0,
                  color: Color.fromRGBO(63, 63, 63, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          (!_game.isDealerTurn)
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayingCardWidget(card: _game.dealer.hand[0], width: 80),
                  SizedBox(width: 10.0),
                  Image.asset(
                    'assets/cards/CARDBACK.png',
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ],
              )
              : CardRow(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                cards:
                    _game.dealer.hand.map((card) {
                      return PlayingCardWidget(card: card, width: 70);
                    }).toList(),
                cardSpacing: 8.0,
                cardWidth: 80,
              ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

Widget _buildBottomPlayersSection() {
  if (_game.showBetPrompt) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
    );
  }

  final bottomPlayers = _game.players.length > 2
      ? _game.players.sublist(2, min(4, _game.players.length))
      : [];

  if (bottomPlayers.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var player in bottomPlayers)
              Expanded(child: PlayerHandDisplay(player: player)),
            if (bottomPlayers.length < 2) Expanded(child: Container()),
          ],
        ),

        SizedBox(height: 8),

        // Their sums underneath
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(bottomPlayers.length * 2 - 1, (i) {
              if (i % 2 == 0) {
                final p = bottomPlayers[i ~/ 2];
                return Expanded(
                  child: Text(
                    "Sum: ${p.hands[0].sum}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Minecraft',
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 0,
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(width: 12);
              }
            }),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildButtonSection() {
    if (_game.showBetPrompt && !_game.showQuitPrompt) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _game.betMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Reset Bet",
                  onPressed: () {
                    resetInitialBet();
                  },
                ),
                SizedBox(width: 20),
                CustomButton(
                  text: "Confirm Bet",
                  onPressed: () {
                    confirmInitialBet();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "Quit",
              onPressed: () {
                setState(() {
                  _game.showQuitPrompt = true;
                });
              },
            ),
          ],
        ),
      );
    }

    if (_game.showQuitPrompt) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Leave game?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(2.4, 2.4),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "No",
                  width: 78,
                  onPressed: () {
                    setState(() {
                      _game.showQuitPrompt = false;
                    });
                  },
                ),
                SizedBox(width: 50),
                CustomButton(
                  text: "Yes",
                  onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_game.roundOver) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 12),
                ...List.generate(curPlayer.hands.length * 2 - 1, (index) {
                  if (index % 2 == 0) {
                    return Flexible(
                      child: Text(
                        curPlayer.hands[index ~/ 2].handResult,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Minecraft',
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 0,
                              color: Color.fromRGBO(63, 63, 63, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(width: 16);
                  }
                }),
                SizedBox(width: 12),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Quit",
                  onPressed: () {
                    setState(() {
                      _game.showQuitPrompt = true;
                    });
                  },
                ),
                SizedBox(width: 50),
                CustomButton(
                  text: "Play Again",
                  onPressed: () {
                    setState(() {
                      _game.showBetPrompt = true;
                      _game.startGame();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              CustomButton(
                text: "Hit",
                onPressed: () {
                  hit();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Stand",
                onPressed: () {
                  stand();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Double Down",
                onPressed: () {
                  doubleDown();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Insurance",
                onPressed: () {
                  insurance();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Split",
                onPressed: () {
                  split();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Surrender",
                onPressed: () {
                  surrender();
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
              CustomButton(
                text: "Quit Game",
                onPressed: () {
                  setState(() {
                    _game.showQuitPrompt = true;
                  });
                },
                fontSize: 16,
                shadowOffset: Offset(2, 2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerHandDisplay extends StatelessWidget {
  final Player player;

  const PlayerHandDisplay({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: LayoutBuilder(builder: (context, constraints) {
        // Reserve a bit of space for padding
        final double cardRowWidth = constraints.maxWidth - 16;

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(23, 107, 61, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                "${player.name} • \$${player.funds} • Bet \$${player.hands[0].bet}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 0,
                      color: Color.fromRGBO(63, 63, 63, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              SizedBox(
                width: cardRowWidth,
                child: CardRow(
                  maxWidth: cardRowWidth,
                  cards: player.hands[0].hand
                      .map((card) => PlayingCardWidget(card: card, width: 65))
                      .toList(),
                  cardSpacing: 16, 
                  cardWidth: 65,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}