import 'package:boop/grid.dart';
import 'package:boop/possibility.dart';
import 'package:flutter/material.dart';

class ViewPossibilitiesScreen extends StatefulWidget {
  final List<Possibility> possibilities;
  final Function refreshMyGamePageState;
  final Function alternatePlayerOneTurn;
  final bool playerOneTurn;
  final String? winner;
  const ViewPossibilitiesScreen({
    super.key,
    required this.possibilities,
    required this.refreshMyGamePageState,
    required this.alternatePlayerOneTurn,
    required this.playerOneTurn,
    required this.winner,
  });

  @override
  State<ViewPossibilitiesScreen> createState() => _ViewPossibilitiesScreenState();
}

class _ViewPossibilitiesScreenState extends State<ViewPossibilitiesScreen> {
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
    Possibility mainPossibility = widget.possibilities[index];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: const Text(
          'Possibilities',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 500,
                width: 500,
                child: Grid(
                  board: mainPossibility.futureBoard,
                  playerOne: mainPossibility.player,
                  playerTwo: mainPossibility.otherPlayer,
                  refreshMyGamePageState: widget.refreshMyGamePageState,
                  alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
                  playerOneTurn: widget.playerOneTurn,
                  winner: widget.winner,
                ),
              ),
              const SizedBox(width: 100),
              Text(
                  'Orange Kittens: ${mainPossibility.otherPlayer.kittens.length}\nOrange Cats: ${mainPossibility.otherPlayer.cats.length}\nGrey Kittens: ${mainPossibility.player.kittens.length}\nGrey Cats: ${mainPossibility.player.cats.length}\n\nScore: ${mainPossibility.score}'),
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
    );
  }
}
