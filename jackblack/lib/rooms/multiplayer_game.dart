import 'package:flutter/material.dart';
import 'package:jackblack/rooms/room.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MultiplayerGamePage extends StatefulWidget {
  final Room room;

  const MultiplayerGamePage({required this.room, super.key});

  @override
  State<MultiplayerGamePage> createState() => _MultiplayerGamePageState();
}

class _MultiplayerGamePageState extends State<MultiplayerGamePage> {
  final Shoe shoe = Shoe(6);
  final RoomService _roomService = RoomService();
  final List<Player> players = [];
  final DealerHand dealer = DealerHand();
  bool isGameStarted = false;
  int currentPlayerIndex = 0;
  bool isDealerTurn = false;
  String _gameMessage = "Waiting for players...";

  @override
  void initState() {
    super.initState();
    _initializePlayers();
    _subscribeToRoom();
  }

  void _initializePlayers() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    for (final playerId in widget.room.playerIds) {
      players.add(
        Player(
          name: playerId == user.id ? "You" : "Player ${players.length + 1}",
          funds: 1000.0,
        ),
      );
    }
  }

  void _subscribeToRoom() {
    _roomService.subscribeToRoom(widget.room.id).listen((room) {
      if (room.isGameStarted && !isGameStarted) {
        setState(() {
          isGameStarted = true;
          _startGame();
        });
      }
    });
  }

  void _startGame() {
    setState(() {
      // Deal initial cards
      for (final player in players) {
        player.addEmptyHand();
        player.hands[0].add(shoe.deal());
        player.hands[0].add(shoe.deal());
      }
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      _gameMessage = "Game started!";
    });
  }

  void _hit() {
    setState(() {
      final currentPlayer = players[currentPlayerIndex];
      currentPlayer.hit(currentPlayer.hands[0], shoe);

      if (currentPlayer.hands[0].sum > 21) {
        _gameMessage = "${currentPlayer.name} busted!";
        _nextPlayer();
      }
    });
  }

  void _stand() {
    _nextPlayer();
  }

  void _nextPlayer() {
    setState(() {
      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) {
        isDealerTurn = true;
        _dealerPlay();
      } else {
        _gameMessage = "${players[currentPlayerIndex].name}'s turn";
      }
    });
  }

  void _dealerPlay() {
    setState(() {
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }
      _checkResults();
    });
  }

  void _checkResults() {
    setState(() {
      final dealerScore = dealer.sum;
      for (final player in players) {
        final playerScore = player.hands[0].sum;
        if (playerScore > 21) {
          _gameMessage = "${player.name} busted!";
        } else if (dealerScore > 21) {
          _gameMessage = "Dealer busted! ${player.name} wins!";
          player.funds += 2 * player.hands[0].bet;
        } else if (playerScore > dealerScore) {
          _gameMessage = "${player.name} wins!";
          player.funds += 2 * player.hands[0].bet;
        } else if (playerScore < dealerScore) {
          _gameMessage = "Dealer wins against ${player.name}!";
        } else {
          _gameMessage = "${player.name} ties with dealer!";
          player.funds += player.hands[0].bet;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      appBar: AppBar(
        title: Text('Room ${widget.room.id.substring(0, 8)}'),
        backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _gameMessage,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Dealer",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                        dealer.hand
                            .map((card) => PlayingCardWidget(card: card))
                            .toList(),
                  ),
                  SizedBox(height: 20),
                  ...players.asMap().entries.map((entry) {
                    final index = entry.key;
                    final player = entry.value;
                    return Column(
                      children: [
                        Text(
                          "${player.name} (${currentPlayerIndex == index ? 'Current Turn' : ''})",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Wrap(
                          spacing: 8,
                          children:
                              player.hands[0].hand
                                  .map((card) => PlayingCardWidget(card: card))
                                  .toList(),
                        ),
                        Text(
                          "Sum: ${player.hands[0].sum}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          if (isGameStarted && currentPlayerIndex < players.length)
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _hit, child: Text('Hit')),
                  ElevatedButton(onPressed: _stand, child: Text('Stand')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
