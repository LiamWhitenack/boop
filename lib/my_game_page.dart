import 'package:flutter/material.dart';
import 'grid.dart';
import 'player.dart';
import 'board.dart';

class MyGamePage extends StatefulWidget {
  const MyGamePage({
    super.key,
    required this.title,
    required this.playerOne,
    required this.playerTwo,
    required this.board,
  });
  final String title;
  final Player playerOne;
  final Player playerTwo;
  final Board board;

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  // used to alternate turns
  bool playerOneTurn = true;

  // this variable is null if there is no winner yet, else their name
  String? winner;

  // these are user inputs
  String? pieceType;
  int? row;
  int? column;

  void refreshMyGamePageState() {
    playerOneTurn = !playerOneTurn;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Player activePlayer = playerOneTurn ? widget.playerOne : widget.playerTwo;
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
            SizedBox(
              height: limitingSize / 1.5,
              width: limitingSize / 1.5,
              child: Grid(
                board: widget.board,
                playerOne: widget.playerOne,
                playerTwo: widget.playerTwo,
                refreshMyGamePageState: refreshMyGamePageState,
              ),
            ),
            SizedBox(
              height: screenHeight / 8,
              width: limitingSize / 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  activePlayer.cats.isNotEmpty
                      // true
                      ? Draggable<String>(
                          data: 'Cat',
                          feedback: FloatingActionButton(
                            child: const Icon(Icons.ac_unit),
                            onPressed: () {},
                          ),
                          child: FloatingActionButton(
                            child: const Icon(Icons.ac_unit),
                            onPressed: () {},
                          ),
                        )
                      : const SizedBox(),
                  // activePlayer.cats.isNotEmpty && activePlayer.kittens.isNotEmpty
                  //     ? Expanded(
                  //         flex: 1,
                  //         child: Container(
                  //           color: Colors.green,
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  activePlayer.kittens.isNotEmpty
                      // true
                      ? Draggable<String>(
                          data: 'Kitten',
                          feedback: FloatingActionButton(
                            child: const Icon(Icons.ac_unit),
                            onPressed: () {},
                          ),
                          child: FloatingActionButton(
                            child: const Icon(Icons.ac_unit),
                            onPressed: () {},
                          ),
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
