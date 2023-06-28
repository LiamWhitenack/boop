import 'package:boop/grid.dart';
import 'package:boop/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewGameStatesScreen extends StatefulWidget {
  final List<GameState> possibilities;
  final Function refreshMyGamePageState;
  final Function alternatePlayerOneTurn;
  final bool playerOneTurn;
  final String? winner;
  const ViewGameStatesScreen({
    super.key,
    required this.possibilities,
    required this.refreshMyGamePageState,
    required this.alternatePlayerOneTurn,
    required this.playerOneTurn,
    required this.winner,
  });

  @override
  State<ViewGameStatesScreen> createState() => _ViewGameStatesScreenState();
}

class _ViewGameStatesScreenState extends State<ViewGameStatesScreen> {
  int index = 0;

  void increaseIndex() {
    if (index != widget.possibilities.length - 1) {
      index++;
      setState(() {});
    }
  }

  void decreaseIndex() {
    if (index != 0) {
      index--;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    GameState mainGameState = widget.possibilities[index];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: const Text(
          'GameStates',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: RawKeyboardListener(
        focusNode: focusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            if (event is RawKeyDownEvent) {
              decreaseIndex();
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            if (event is RawKeyDownEvent) {
              increaseIndex();
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 500,
                  width: 500,
                  child: Grid(
                    gameState: mainGameState,
                    refreshMyGamePageState: widget.refreshMyGamePageState,
                    alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
                  ),
                ),
                const SizedBox(width: 100),
                Column(
                  children: [
                    Text('Orange Kittens: ${mainGameState.playerOne.tempKittens.length}'),
                    Text('Orange Cats: ${mainGameState.playerOne.tempCats.length}'),
                    Text('Grey Kittens: ${mainGameState.playerTwo.tempKittens.length}'),
                    Text('Grey Cats: ${mainGameState.playerTwo.tempCats.length}'),
                    const Text(''),
                    Text('Score: ${mainGameState.score.toStringAsPrecision(4)}'),
                    Text('Score From Positioning: ${mainGameState.scoreFromPositioning.toStringAsPrecision(4)}'),
                    Text(
                        'Score From Proximity to Other Owned Pieces: ${mainGameState.scoreFromPieceProximity.toStringAsPrecision(4)}'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                index != 0
                    ? TextButton(
                        onPressed: () {
                          decreaseIndex();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 50,
                          width: 75,
                          // color: Colors.blue,
                          child: const Icon(
                            Icons.arrow_left_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    : const SizedBox(width: 75),
                const SizedBox(width: 50, height: 50),
                index != widget.possibilities.length - 1
                    ? TextButton(
                        onPressed: () {
                          increaseIndex();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 50,
                          width: 75,
                          // color: Colors.blue,
                          child: const Center(
                            child: Icon(
                              Icons.arrow_right_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(width: 75),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
