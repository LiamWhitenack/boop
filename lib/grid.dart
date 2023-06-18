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

  Grid({
    super.key,
    required this.board,
    required this.playerOne,
    required this.playerTwo,
    required this.refreshMyGamePageState,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<List<bool>> isDragOver = List.generate(6, (row) => List.filled(6, true));
  String? winner;
  bool playerOneTurn = true;
  Color getCellColor(dynamic value, Player playerOne) {
    if (value == null) {
      return Colors.red;
    }
    if (value.player == playerOne) {
      return Colors.blue;
    } else {
      return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (winner != null) {
      return Text('$winner wins!');
    }

    Player activePlayer = playerOneTurn ? widget.playerOne : widget.playerTwo;

    return GridView.builder(
      itemCount: 36,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.board.tempGrid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ widget.board.tempGrid[0].length;
        int column = index % widget.board.tempGrid[0].length;
        Color cellColor = getCellColor(widget.board.tempGrid[row][column], widget.playerOne);
        return DragTarget<String>(
          onAccept: (value) {
            widget.board.updateGrid();
            if (widget.board.checkForWin() != null) {
              winner = widget.board.checkForWin();
            }

            widget.board.upgradeThreeInARows();

            playerOneTurn = !playerOneTurn;

            isDragOver[row][column] = false;
            setState(() {});
            widget.refreshMyGamePageState();
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
            return widget.board.grid[row][column] == null;
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                color: cellColor,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  widget.board.tempGrid[row][column]?.toString() ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
