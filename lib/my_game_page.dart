import 'package:flutter/material.dart';
import 'game_over_screen.dart';
import 'grid.dart';
import 'kittens_and_cats.dart';
import 'player.dart';
import 'board.dart';

class MyGamePage extends StatefulWidget {
  const MyGamePage({
    super.key,
    required this.title,
    required this.playerOne,
    required this.playerTwo,
    required this.board,
    required this.playerOneTurn,
    this.winner,
    required this.alternatePlayerOneTurn,
    required this.startOver,
  });
  final String title;
  final Player playerOne;
  final Player playerTwo;
  final Board board;
  final bool playerOneTurn;
  final String? winner;
  final Function alternatePlayerOneTurn;
  final Function startOver;

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  // these are user inputs
  String? pieceType;
  int? row;
  int? column;

  void refreshMyGamePageState() {
    widget.alternatePlayerOneTurn();
    setState(() {});
  }

  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    if (widget.winner != null) {
      return GameOverScreen(
        winner: widget.winner!,
        startOver: widget.startOver,
      );
    }
    // ignore: dead_code
    Player activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;
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
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: gridLength,
                width: gridLength,
                child: Grid(
                  board: widget.board,
                  playerOne: widget.playerOne,
                  playerTwo: widget.playerTwo,
                  playerOneTurn: widget.playerOneTurn,
                  winner: widget.winner,
                  alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
                  refreshMyGamePageState: refreshMyGamePageState,
                ),
              ),
              Container(
                color: Colors.white10,
                height: screenHeight * 0.1,
                width: gridLength * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // cats
                    activePlayer.cats.isNotEmpty
                        // true
                        ? Draggable<String>(
                            data: 'Cat',
                            feedback: CatWidget(catColor: activePlayer.color),
                            child: CatWidget(catColor: activePlayer.color))
                        : const SizedBox(),
                    // space between
                    activePlayer.cats.isNotEmpty && activePlayer.kittens.isNotEmpty
                        ? SizedBox(width: gridLength * 0.3)
                        : const SizedBox(),
                    // kittens
                    activePlayer.kittens.isNotEmpty
                        ? Draggable<String>(
                            data: 'Kitten',
                            feedback: KittenWidget(kittenColor: activePlayer.color),
                            child: KittenWidget(kittenColor: activePlayer.color),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
