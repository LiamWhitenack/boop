import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';
// import 'kittens_and_cats.dart';

// ignore: must_be_immutable
class Grid extends StatefulWidget {
  final Board board;
  final Player playerOne;
  final Player playerTwo;
  final Function refreshMyGamePageState;
  final Function alternatePlayerOneTurn;
  final bool playerOneTurn;
  final String? winner;

  const Grid({
    super.key,
    required this.board,
    required this.playerOne,
    required this.playerTwo,
    required this.refreshMyGamePageState,
    required this.alternatePlayerOneTurn,
    required this.playerOneTurn,
    required this.winner,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<List<bool>> isDragOver = List.generate(6, (row) => List.filled(6, true));
  Color getCellColor(int row, int column) {
    return widget.board.colorGrid[row][column];
  }

  @override
  Widget build(BuildContext context) {
    // List<List<int>> threeInARows = widget.board.findAllThreeInARow()[0];
    if (widget.winner != null) {
      return Text('${widget.winner} wins!');
    }

    Player activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;
    // if (activePlayer.kittens.isEmpty && activePlayer.cats.isEmpty) {
    //   widget.alternatePlayerOneTurn();
    // }
    // activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;
    // // widget.refreshMyGamePageState();

    return GridView.builder(
      itemCount: 36,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.board.tempGrid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ widget.board.tempGrid[0].length;
        int column = index % widget.board.tempGrid[0].length;
        Color cellColor = getCellColor(row, column);
        return DragTarget<String>(
          onAccept: (value) {
            isDragOver[row][column] = false;
            setState(() {});
          },
          onLeave: (value) {
            widget.board.undoLastBoop();
            isDragOver[row][column] = false;
            widget.refreshMyGamePageState();
          },
          onWillAccept: (value) {
            if (widget.playerOne.tempKittens.isEmpty &&
                widget.playerTwo.tempCats.isEmpty &&
                widget.playerOne.tempCats.isEmpty &&
                widget.playerTwo.tempKittens.isEmpty) {
              throw Exception('All out of pieces to place!');
            }
            if (value == 'Kitten') {
              widget.board.boopKitten(row, column, activePlayer, widget.winner);
            } else if (value == 'Cat') {
              widget.board.boopCat(row, column, activePlayer, widget.winner);
            }
            isDragOver[row][column] = true;

            // testing only
            // widget.board.setUpPlayerForWinning(widget.playerOne);
            // widget.board.setUpPlayerForScoring(widget.playerOne);

            widget.refreshMyGamePageState();
            return widget.board.grid[row][column] == null;
          },
          builder: (context, candidateData, rejectedData) {
            late Widget cellContents;
            if (widget.board.tempGrid[row][column] != null) {
              cellContents = widget.board.tempGrid[row][column].widget;
            } else {
              cellContents = const SizedBox();
            }
            return Container(
              decoration: BoxDecoration(
                color: cellColor,
                border: Border.all(color: Colors.white60, width: 2),
              ),
              child: cellContents,
            );
          },
        );
      },
    );
  }
}
