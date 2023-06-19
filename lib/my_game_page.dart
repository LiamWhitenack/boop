import 'package:flutter/material.dart';
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
  });
  final String title;
  final Player playerOne;
  final Player playerTwo;
  final Board board;
  final bool playerOneTurn;
  final String? winner;
  final Function alternatePlayerOneTurn;

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
  Widget build(BuildContext context) {
    Player activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),
            SizedBox(
              height: limitingSize * 0.65,
              width: limitingSize * 0.65,
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
            SizedBox(
              height: screenHeight * 0.125,
              width: limitingSize * 0.7,
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
                      ? SizedBox(width: limitingSize * 0.2)
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
    );
  }
}
