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
    // widget.alternatePlayerOneTurn();
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
    final Player activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;
    final Player otherPlayer = widget.playerOneTurn ? widget.playerTwo : widget.playerOne;
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
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  // ohter player's pieces
                  SizedBox(
                    width: gridLength + 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // cats
                        SizedBox(
                          width: otherPlayer.tempCats.isNotEmpty ? gridLength * 0.35 : 0,
                          child: otherPlayer.tempCats.isNotEmpty
                              // true
                              ? Row(
                                  children: [
                                    CatWidget(catColor: otherPlayer.color),
                                    Text(
                                      ' x ${otherPlayer.tempCats.length}',
                                      style: TextStyle(fontSize: 40, color: otherPlayer.color),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        // space between
                        otherPlayer.tempCats.isNotEmpty && otherPlayer.tempKittens.isNotEmpty
                            ? SizedBox(width: gridLength * 0.1)
                            : const SizedBox(),
                        // kittens
                        // ignore: sized_box_for_whitespace
                        SizedBox(
                          width: otherPlayer.tempKittens.isNotEmpty ? gridLength * 0.35 : 0,
                          child: otherPlayer.tempKittens.isNotEmpty
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    KittenWidget(kittenColor: otherPlayer.color),
                                    Text(
                                      ' x ${otherPlayer.tempKittens.length}',
                                      style: TextStyle(fontSize: 40, color: otherPlayer.color),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
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
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    color: Colors.white10,
                    height: screenHeight * 0.1,
                    width: gridLength * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // cats
                        SizedBox(
                          // color: Colors.black,
                          width: activePlayer.tempCats.isNotEmpty ? gridLength * 0.35 : 0,
                          child: activePlayer.tempCats.isNotEmpty
                              // true
                              ? Row(
                                  children: [
                                    Draggable<String>(
                                        onDragStarted: () {
                                          widget.board.undoLastBoop();
                                        },
                                        data: 'Cat',
                                        feedback: CatWidget(catColor: activePlayer.color),
                                        child: CatWidget(catColor: activePlayer.color)),
                                    Text(
                                      ' x ${activePlayer.tempCats.length}',
                                      style: TextStyle(fontSize: 40, color: activePlayer.color),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        // space between
                        activePlayer.tempCats.isNotEmpty && activePlayer.tempKittens.isNotEmpty
                            ? SizedBox(width: gridLength * 0.1)
                            : const SizedBox(),
                        // tempKittens
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: activePlayer.tempKittens.isNotEmpty ? gridLength * 0.35 : 0,
                          child: activePlayer.tempKittens.isNotEmpty
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Draggable<String>(
                                      onDragStarted: () {
                                        widget.board.undoLastBoop();
                                      },
                                      data: 'Kitten',
                                      feedback: KittenWidget(kittenColor: activePlayer.color),
                                      child: KittenWidget(kittenColor: activePlayer.color),
                                    ),
                                    Text(
                                      ' x ${activePlayer.tempKittens.length}',
                                      style: TextStyle(fontSize: 40, color: activePlayer.color),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
