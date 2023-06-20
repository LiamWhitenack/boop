// import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'my_game_page.dart';

void main() {
  Player playerOne = Player('Maire', Colors.orange);
  Player playerTwo = Player('Emily', Colors.grey);
  // playGame();
  runApp(MyApp(
    board: Board(playerOne, playerTwo),
    playerOne: playerOne,
    playerTwo: playerTwo,
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

    // widget.board.upgradeThreeInARows();

    widget.board.playerOne.updateKittensAndCats();
    widget.board.playerTwo.updateKittensAndCats();

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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    final double gridLength = limitingSize == screenWidth ? screenWidth * 0.95 : limitingSize * 0.65;
    String playerTurn = playerOneTurn ? widget.playerOne.name : widget.playerTwo.name;
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        useMaterial3: true,
      ),
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
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: gridLength * 0.1,
                ),
              )
            : null,
      ),
    );
  }
}
