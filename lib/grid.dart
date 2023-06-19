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
    // if (row == placementRow && column == placementColumn) {
    //   return Colors.blue.shade200;
    // }
    if (widget.board.cellGoingToBeChangedOnUpdate(row, column)) {
      return Colors.blue.shade100;
    }
    return Colors.blue.shade200;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.winner != null) {
      return Text('${widget.winner} wins!');
    }

    Player activePlayer = widget.playerOneTurn ? widget.playerOne : widget.playerTwo;

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
            setState(() {
              widget.board.undoLastBoop(activePlayer);
              isDragOver[row][column] = false;
            });
          },
          onWillAccept: (value) {
            setState(() {
              if (widget.playerOne.kittens.isEmpty &&
                  widget.playerTwo.cats.isEmpty &&
                  widget.playerOne.cats.isEmpty &&
                  widget.playerTwo.kittens.isEmpty) {
                throw Exception('All out of pieces to place!');
              }
              if (value == 'Kitten') {
                widget.board.boopKitten(row, column, activePlayer);
              } else if (value == 'Cat') {
                widget.board.boopCat(row, column, activePlayer);
              }
              isDragOver[row][column] = true;
            });
            // testing only
            // widget.board.setUpPlayerForWinning(widget.playerOne);
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
