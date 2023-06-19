// import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'my_game_page.dart';

void main() {
  // playGame();
  runApp(MyApp(
    board: Board(),
    playerOne: Player('Ralph', Colors.orange),
    playerTwo: Player('Jack', Colors.grey),
  ));
}

class MyApp extends StatefulWidget {
  final Board board;
  final Player playerOne;
  final Player playerTwo;

  const MyApp({
    super.key,
    required this.board,
    required this.playerOne,
    required this.playerTwo,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? winner;
  bool playerOneTurn = true;

  void confirmMove() {
    widget.board.updateGrid();

    // this will usually return null, otherwise winning player's name
    winner = widget.board.checkForWin();

    widget.board.upgradeThreeInARows();

    alternatePlayerOneTurn();
    setState(() {});
  }

  void alternatePlayerOneTurn() {
    playerOneTurn = !playerOneTurn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MyGamePage(
          title: 'Boop. Game',
          playerOne: widget.playerOne,
          playerTwo: widget.playerTwo,
          board: widget.board,
          winner: winner,
          playerOneTurn: playerOneTurn,
          alternatePlayerOneTurn: alternatePlayerOneTurn,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: confirmMove,
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
