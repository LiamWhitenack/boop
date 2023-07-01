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
  late List<GameState> previousGameStates;
  late int gameStateIndex;
  @override
  void initState() {
    super.initState();
    previousGameStates = [widget.gameState.clone()];
    gameStateIndex = 0;
  }

  void addGameStateToList() {
    previousGameStates.add(widget.gameState.clone());
    gameStateIndex++;
  }

  void changeGameStateIndex(int changeBy) {
    gameStateIndex = gameStateIndex + changeBy;
  }

  void loadGameState(GameState gameState) {
    widget.gameState.conform(gameState);
    setState(() {});
  }

  void confirmMove() {
    previousGameStates.removeRange(gameStateIndex + 1, previousGameStates.length);

    confirmMoveAndalternateTurn();
    takeTurnIfOpponentIsAI();
    addGameStateToList();
    setState(() {});
  }

  // ===========================================================================
  // =========================== IN PROGRESS ===================================
  void confirmMoveAndalternateTurn() {
    Player otherPlayer = widget.gameState.playerOneTurn ? widget.gameState.playerTwo : widget.gameState.playerOne;
    if (widget.gameState.board.boardChanged()) {
      widget.gameState.board.updateGrid();
      widget.gameState.board.playerOne.updateKittensAndCats();
      widget.gameState.board.playerTwo.updateKittensAndCats();

      if (otherPlayer.kittens.isEmpty && otherPlayer.cats.isEmpty) {
        return;
      }
      if (widget.gameState.board.winner != null) {
        widget.gameState.gameOver = true;
        setState(() {});
        return;
      }
      widget.gameState.playerOneTurn = !widget.gameState.playerOneTurn;
      widget.gameState.updateActivePlayer();
    }
    if (widget.gameState.board.winner != null) {
      widget.gameState.gameOver = true;
    }
  }

  void takeTurnIfOpponentIsAI() {
    GameState future;
    Player activePlayer = widget.gameState.playerOneTurn ? widget.gameState.playerOne : widget.gameState.playerTwo;
    if (activePlayer.automaticallyTakeTurns) {
      future = widget.gameState.generateAllFuturePossibilites(widget.gameState)[0];
      future.board.updateGrid();
      future.board.playerOne.updateKittensAndCats();
      future.board.playerTwo.updateKittensAndCats();

      loadGameState(future);
      // addGameStateToList();
      if (widget.gameState.board.winner != null) {
        widget.gameState.gameOver = true;
      }
    }
  }

  void startOver() {
    widget.gameState.gameOver = false;
    widget.gameState.board.reset();
    widget.gameState.playerOne.reset();
    widget.gameState.playerTwo.reset();
    widget.gameState.playerOneTurn = true;
    widget.gameState.updateActivePlayer();
    previousGameStates = [widget.gameState.clone()];
    gameStateIndex = 0;
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
          title: widget.gameState.board.winner == null ? "$playerTurn's Turn" : 'Game Over',
          gameState: widget.gameState,
          alternatePlayerOneTurn: confirmMoveAndalternateTurn,
          startOver: startOver,
          loadGameState: loadGameState,
          confirmMove: confirmMove,
          changeGameStateIndex: changeGameStateIndex,
          previousGameStates: previousGameStates,
          gameStateIndex: gameStateIndex,
        ),
      ),
    );
  }
}
