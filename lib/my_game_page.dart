import 'package:boop/game_state.dart';
import 'package:boop/view_possibilities_screen.dart';
import 'package:flutter/material.dart';
import 'game_over_screen.dart';
import 'grid.dart';
import 'kittens_and_cats.dart';
// import 'board.dart';

class MyGamePage extends StatefulWidget {
  const MyGamePage({
    super.key,
    required this.title,
    required this.gameState,
    required this.alternatePlayerOneTurn,
    required this.startOver,
    required this.loadGameState,
  });
  final String title;
  final GameState gameState;
  final Function alternatePlayerOneTurn;
  final Function startOver;
  final Function loadGameState;

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  // these are user inputs
  String? pieceType;
  int? row;
  int? column;

  late TextEditingController playerOneNameEditingController;
  late TextEditingController playerTwoNameEditingController;

  void refreshMyGamePageState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    playerOneNameEditingController = TextEditingController(text: widget.gameState.playerOne.name);
    playerTwoNameEditingController = TextEditingController(text: widget.gameState.playerTwo.name);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameState.winner != null) {
      return GameOverScreen(
        winner: widget.gameState.winner!,
        startOver: widget.startOver,
      );
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    final double gridLength = limitingSize == screenWidth ? screenWidth * 0.95 : limitingSize * 0.65;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 25),
        ),
      ),
      drawer: Drawer(
        width: 250,
        child: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                TextField(
                  decoration: const InputDecoration(label: Text('Player One Name')),
                  controller: playerOneNameEditingController,
                  onChanged: (value) {
                    widget.gameState.playerOne.name = playerOneNameEditingController.text;
                  },
                  onEditingComplete: () => refreshMyGamePageState(),
                ),
                // TextField()

                TextField(
                  decoration: const InputDecoration(label: Text('Player Two Name')),
                  controller: playerTwoNameEditingController,
                  onChanged: (value) {
                    widget.gameState.playerTwo.name = playerTwoNameEditingController.text;
                    refreshMyGamePageState();
                  },
                ),

                ListTile(
                  title: const Center(child: Text('Start Over')),
                  onTap: () {
                    widget.startOver();
                    refreshMyGamePageState();
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  title: const Text('View GameStates'),
                  onTap: () {
                    List<GameState> allFutureGameStates =
                        widget.gameState.generateAllFuturePossibilites(widget.gameState);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewGameStatesScreen(
                          // possibilities: [GameState(widget.board, widget.playerTwo, widget.playerOne)],
                          possibilities: allFutureGameStates,
                          refreshMyGamePageState: refreshMyGamePageState,
                          alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
                          playerOneTurn: widget.gameState.playerOneTurn,
                          winner: widget.gameState.winner,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ohter player's pieces
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // cats
                  widget.gameState.otherPlayer.tempCats.isNotEmpty
                      // true
                      ? Row(
                          children: [
                            CatWidget(catColor: widget.gameState.otherPlayer.color),
                            Text(
                              ' x ${widget.gameState.otherPlayer.tempCats.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: widget.gameState.otherPlayer.color),
                            ),
                          ],
                        )
                      : SizedBox(height: gridLength * 0.08),
                  // space between
                  widget.gameState.otherPlayer.tempCats.isNotEmpty &&
                          widget.gameState.otherPlayer.tempKittens.isNotEmpty
                      ? SizedBox(width: gridLength * 0.1)
                      : const SizedBox(),
                  // kittens
                  // ignore: sized_box_for_whitespace
                  widget.gameState.otherPlayer.tempKittens.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            KittenWidget(kittenColor: widget.gameState.otherPlayer.color),
                            Text(
                              ' x ${widget.gameState.otherPlayer.tempKittens.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: widget.gameState.otherPlayer.color),
                            ),
                          ],
                        )
                      : SizedBox(height: gridLength * 0.08),
                ],
              ),

              SizedBox(
                height: gridLength + screenHeight * 0.1,
                child: Center(
                  child: SizedBox(
                    height: gridLength,
                    width: gridLength,
                    child: Grid(
                      gameState: widget.gameState,
                      alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
                      refreshMyGamePageState: refreshMyGamePageState,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // cats
                  widget.gameState.activePlayer.tempCats.isNotEmpty
                      // true
                      ? Row(
                          children: [
                            Draggable<String>(
                                onDragStarted: () {
                                  widget.gameState.board.undoLastBoop();
                                  refreshMyGamePageState();
                                },
                                data: 'Cat',
                                feedback: CatWidget(catColor: widget.gameState.activePlayer.color),
                                child: CatWidget(catColor: widget.gameState.activePlayer.color)),
                            Text(
                              ' x ${widget.gameState.activePlayer.tempCats.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: widget.gameState.activePlayer.color),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  // space between
                  widget.gameState.activePlayer.tempCats.isNotEmpty &&
                          widget.gameState.activePlayer.tempKittens.isNotEmpty
                      ? SizedBox(width: gridLength * 0.1)
                      : const SizedBox(),
                  // tempKittens
                  widget.gameState.activePlayer.tempKittens.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Draggable<String>(
                              onDragStarted: () {
                                widget.gameState.board.undoLastBoop();
                                refreshMyGamePageState();
                              },
                              data: 'Kitten',
                              feedback: KittenWidget(kittenColor: widget.gameState.activePlayer.color),
                              child: KittenWidget(kittenColor: widget.gameState.activePlayer.color),
                            ),
                            Text(
                              ' x ${widget.gameState.activePlayer.tempKittens.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: widget.gameState.activePlayer.color),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
