import 'package:boop/game_state.dart';
import 'package:flutter/material.dart';
import 'my_game_page.dart';
import 'player.dart';

class MyApp extends StatefulWidget {
  final GameState gameState;

  const MyApp({
    super.key,
    required this.gameState,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void confirmMove() {
    // this will usually return null, otherwise winning player's name
    widget.gameState.winner = widget.gameState.board.checkForWin();
    alternatePlayerOneTurn();
    widget.gameState.board.updateGrid();

    // widget.board.upgradeThreeInARows();

    widget.gameState.board.playerOne.updateKittensAndCats();
    widget.gameState.board.playerTwo.updateKittensAndCats();

    setState(() {});
  }

  void alternatePlayerOneTurn() {
    Player activePlayer = widget.gameState.playerOneTurn ? widget.gameState.playerOne : widget.gameState.playerTwo;
    Player otherPlayer = widget.gameState.playerOneTurn ? widget.gameState.playerTwo : widget.gameState.playerOne;
    if (otherPlayer.kittens.isEmpty && activePlayer.cats.isEmpty) {
      return;
    }
    if (widget.gameState.board.boardChanged()) {
      widget.gameState.playerOneTurn = !widget.gameState.playerOneTurn;
      return;
    }
    return;
  }

  void startOver() {
    widget.gameState.board.reset();
    widget.gameState.playerOne.reset();
    widget.gameState.playerTwo.reset();
    widget.gameState.winner = null;
    widget.gameState.playerOneTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;
    String playerTurn =
        widget.gameState.playerOneTurn ? widget.gameState.playerOne.name : widget.gameState.playerTwo.name;
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
          useMaterial3: true,
          fontFamily: "Permanent-Marker"),
      home: Scaffold(
        body: MyGamePage(
          title: widget.gameState.winner == null ? "$playerTurn's Turn" : 'Game Over',
          gameState: widget.gameState,
          alternatePlayerOneTurn: alternatePlayerOneTurn,
          startOver: startOver,
        ),
        floatingActionButton: widget.gameState.winner == null
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
