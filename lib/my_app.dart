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
    alternatePlayerOneTurnAgainstIntelligentAI();
  }

  // ===========================================================================
  // =========================== IN PROGRESS ===================================
  void alternatePlayerOneTurnAgainstIntelligentAI() {
    Player otherPlayer;
    GameState future;
    otherPlayer = widget.gameState.playerOneTurn ? widget.gameState.playerTwo : widget.gameState.playerOne;
    if (widget.gameState.board.boardChanged()) {
      widget.gameState.board.updateGrid();
      widget.gameState.board.playerOne.updateKittensAndCats();
      widget.gameState.board.playerTwo.updateKittensAndCats();
      addGameStateToList();
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
      if (otherPlayer.automaticallyTakeTurns) {
        future = widget.gameState.generateAllFuturePossibilites(widget.gameState)[0];

        loadGameState(future);
        // addGameStateToList();
      }
    }
    if (widget.gameState.board.winner != null) {
      widget.gameState.gameOver = true;
    }
    setState(() {});
  }

  void startOver() {
    widget.gameState.gameOver = false;
    widget.gameState.board.reset();
    widget.gameState.playerOne.reset();
    widget.gameState.playerTwo.reset();
    widget.gameState.playerOneTurn = true;
    widget.gameState.updateActivePlayer();
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
          alternatePlayerOneTurn: alternatePlayerOneTurnAgainstIntelligentAI,
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
