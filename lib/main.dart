// import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';
import 'board.dart';
import 'my_app.dart';

void main() {
  Player playerOne = Player('Ralph', Colors.orange);
  Player playerTwo = Player('Jack', Colors.grey);
  // playGame();
  runApp(
    MyApp(
      board: Board(playerOne, playerTwo),
      playerOne: playerOne,
      playerTwo: playerTwo,
    ),
  );
}
