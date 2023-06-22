import 'package:boop/dialogue.dart';
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

  late TextEditingController playerOneNameEditingController;
  late TextEditingController playerTwoNameEditingController;

  void refreshMyGamePageState() {
    // widget.alternatePlayerOneTurn();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    playerOneNameEditingController = TextEditingController(text: widget.playerOne.name);
    playerTwoNameEditingController = TextEditingController(text: widget.playerTwo.name);
  }

  Widget build(BuildContext context) {
    if (widget.winner != null) {
      return GameOverScreen(
        winner: widget.winner!,
        startOver: widget.startOver,
      );
    }
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
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: [
            const ListTile(
              title: Text('Player One Name'),
            ),
            TextField(
              controller: playerOneNameEditingController,
              onChanged: (value) {
                widget.playerOne.name = playerOneNameEditingController.text;
              },
              onEditingComplete: () => refreshMyGamePageState(),
            ),
            // TextField()
            const ListTile(
              title: Text("Player Two Name"),
            ),
            TextField(
              controller: playerTwoNameEditingController,
              onChanged: (value) {
                widget.playerTwo.name = playerTwoNameEditingController.text;
                refreshMyGamePageState();
              },
            ),
          ],
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
                  otherPlayer.tempCats.isNotEmpty
                      // true
                      ? Row(
                          children: [
                            CatWidget(catColor: otherPlayer.color),
                            Text(
                              ' x ${otherPlayer.tempCats.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: otherPlayer.color),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  // space between
                  otherPlayer.tempCats.isNotEmpty && otherPlayer.tempKittens.isNotEmpty
                      ? SizedBox(width: gridLength * 0.1)
                      : const SizedBox(),
                  // kittens
                  // ignore: sized_box_for_whitespace
                  otherPlayer.tempKittens.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            KittenWidget(kittenColor: otherPlayer.color),
                            Text(
                              ' x ${otherPlayer.tempKittens.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: otherPlayer.color),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),

              SizedBox(
                height: gridLength + screenHeight * 0.1,
                child: Center(
                  child: SizedBox(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // cats
                  activePlayer.tempCats.isNotEmpty
                      // true
                      ? Row(
                          children: [
                            Draggable<String>(
                                onDragStarted: () {
                                  widget.board.undoLastBoop();
                                  refreshMyGamePageState();
                                },
                                data: 'Cat',
                                feedback: CatWidget(catColor: activePlayer.color),
                                child: CatWidget(catColor: activePlayer.color)),
                            Text(
                              ' x ${activePlayer.tempCats.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: activePlayer.color),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  // space between
                  activePlayer.tempCats.isNotEmpty && activePlayer.tempKittens.isNotEmpty
                      ? SizedBox(width: gridLength * 0.1)
                      : const SizedBox(),
                  // tempKittens
                  activePlayer.tempKittens.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Draggable<String>(
                              onDragStarted: () {
                                widget.board.undoLastBoop();
                                refreshMyGamePageState();
                              },
                              data: 'Kitten',
                              feedback: KittenWidget(kittenColor: activePlayer.color),
                              child: KittenWidget(kittenColor: activePlayer.color),
                            ),
                            Text(
                              ' x ${activePlayer.tempKittens.length}',
                              style: TextStyle(fontSize: gridLength * 0.08, color: activePlayer.color),
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
