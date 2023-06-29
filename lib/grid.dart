import 'package:flutter/material.dart';
import 'game_state.dart';
// import 'kittens_and_cats.dart';

// ignore: must_be_immutable
class Grid extends StatefulWidget {
  final GameState gameState;
  final Function refreshMyGamePageState;
  final Function alternatePlayerOneTurn;

  const Grid({
    super.key,
    required this.gameState,
    required this.refreshMyGamePageState,
    required this.alternatePlayerOneTurn,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<List<bool>> isDragOver = List.generate(6, (row) => List.filled(6, true));
  Color getCellColor(int row, int column) {
    return widget.gameState.board.colorGrid[row][column];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameState.winner != null) {
      return Center(child: Text('${widget.gameState.winner} wins!'));
    }

    return GridView.builder(
      itemCount: 36,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gameState.board.tempGrid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ widget.gameState.board.tempGrid[0].length;
        int column = index % widget.gameState.board.tempGrid[0].length;
        Color cellColor = getCellColor(row, column);
        return DragTarget<String>(
          onAccept: (value) {
            isDragOver[row][column] = false;
            setState(() {});
          },
          onLeave: (value) {
            widget.gameState.board.undoLastBoop();
            isDragOver[row][column] = false;
            widget.refreshMyGamePageState();
          },
          onWillAccept: (value) {
            if (widget.gameState.playerOne.tempKittens.isEmpty &&
                widget.gameState.playerTwo.tempCats.isEmpty &&
                widget.gameState.playerOne.tempCats.isEmpty &&
                widget.gameState.playerTwo.tempKittens.isEmpty) {
              throw Exception('All out of pieces to place!');
            }
            if (value == 'Kitten') {
              widget.gameState.board.boopKitten(row, column, widget.gameState.activePlayer, widget.gameState.winner);
            } else if (value == 'Cat') {
              widget.gameState.board.boopCat(row, column, widget.gameState.activePlayer, widget.gameState.winner);
            }
            isDragOver[row][column] = true;

            // testing only
            // widget.gameState.board.setUpPlayerForWinning(widget.gameState.playerOne);
            // widget.board.setUpPlayerForScoring(widget.playerOne);

            widget.refreshMyGamePageState();
            return widget.gameState.board.grid[row][column] == null;
          },
          builder: (context, candidateData, rejectedData) {
            late Widget cellContents;
            if (widget.gameState.board.tempGrid[row][column] != null) {
              cellContents = widget.gameState.board.tempGrid[row][column].widget;
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
