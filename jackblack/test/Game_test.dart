import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackblack/game.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';

void main() {
  group('Edge Cases', () {
    late GamePage gamePage;
    late GamePageState gameState;

    setUp(() {
      gamePage = const GamePage();
      gameState = GamePageState();
    });

    test('Multiple Aces in hand', () {
      // Test multiple aces (should count one as 11 and others as 1)
      gameState.curHand.add(PlayingCard(suit: 'H', rank: 'A'));
      gameState.curHand.add(PlayingCard(suit: 'D', rank: 'A'));
      gameState.curHand.add(PlayingCard(suit: 'S', rank: 'A'));
      expect(gameState.curHand.sum, equals(13)); // 11 + 1 + 1
    });
}
