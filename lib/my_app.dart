import 'package:flutter/material.dart';
import 'board.dart';
import 'my_game_page.dart';
import 'player.dart';

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
    // this will usually return null, otherwise winning player's name
    winner = widget.board.checkForWin();
    alternatePlayerOneTurn();
    widget.board.updateGrid();

    // widget.board.upgradeThreeInARows();

    widget.board.playerOne.updateKittensAndCats();
    widget.board.playerTwo.updateKittensAndCats();

    setState(() {});
  }

  void alternatePlayerOneTurn() {
    Player activePlayer = playerOneTurn ? widget.playerOne : widget.playerTwo;
    Player otherPlayer = playerOneTurn ? widget.playerTwo : widget.playerOne;
    if (otherPlayer.kittens.isEmpty && activePlayer.cats.isEmpty) {
      return;
    }
    if (widget.board.boardChanged()) {
      playerOneTurn = !playerOneTurn;
      return;
    }
    return;
  }

  void startOver() {
    widget.board.reset();
    widget.playerOne.reset();
    widget.playerTwo.reset();
    winner = null;
    playerOneTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;
    String playerTurn = playerOneTurn ? widget.playerOne.name : widget.playerTwo.name;
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
          useMaterial3: true,
          fontFamily: "Permanent-Marker"),
      home: Scaffold(
        body: MyGamePage(
          title: winner == null ? "$playerTurn's Turn" : 'Game Over',
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
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.0,
                ),
              )
            : null,
      ),
    );
  }
}