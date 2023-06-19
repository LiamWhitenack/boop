// import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'my_game_page.dart';

void main() {
  // playGame();
  runApp(MyApp(
    board: Board(),
    playerOne: Player('Maire', Colors.orange),
    playerTwo: Player('Emily', Colors.grey),
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

  void startOver() {
    widget.board.reset();
    widget.playerOne.reset();
    widget.playerTwo.reset();
    winner = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String playerTurn = playerOneTurn ? widget.playerOne.name : widget.playerTwo.name;
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MyGamePage(
          title: winner != null ? "$playerTurn's Turn" : 'Game Over',
          playerOne: widget.playerOne,
          playerTwo: widget.playerTwo,
          board: widget.board,
          winner: winner,
          playerOneTurn: playerOneTurn,
          alternatePlayerOneTurn: alternatePlayerOneTurn,
          startOver: startOver,
        ),
        floatingActionButton: winner == null
            ? FloatingActionButton(
                backgroundColor: Colors.blue.shade400,
                onPressed: confirmMove,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.08,
                ),
              )
            : null,
      ),
    );
  }
}
