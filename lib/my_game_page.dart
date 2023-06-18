import 'package:flutter/material.dart';
import 'game_flow.dart';
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

  void onTappedCell(int newRow, int newColumn) {
    if (winner != null) return;
    if (widget.board.grid[newRow][newColumn] != null) return;
    setState(() {
      row = newRow;
      column = newColumn;
      pieceType = 'Kitten';
      if (widget.playerOne.kittens.isEmpty &&
          widget.playerTwo.cats.isEmpty &&
          widget.playerOne.cats.isEmpty &&
          widget.playerTwo.kittens.isEmpty) {
        throw Exception('All out of pieces to place!');
      }
      if (widget.playerOne.kittens.isEmpty && widget.playerOne.cats.isEmpty) {
        winner = takeTurn(widget.board, widget.playerTwo, pieceType!, row!, column!);
      } else if (widget.playerTwo.kittens.isEmpty && widget.playerTwo.cats.isEmpty) {
        winner = takeTurn(widget.board, widget.playerOne, pieceType!, row!, column!);
      } else if (playerOneTurn) {
        winner = takeTurn(widget.board, widget.playerOne, pieceType!, row!, column!);
      } else {
        winner = takeTurn(widget.board, widget.playerTwo, pieceType!, row!, column!);
      }
      if (winner != null) {
        print('$winner wins!');
      }
      playerOneTurn = !playerOneTurn;
    });
  }

  void onAccept(cellColors, isDragOver, newRow, newColumn) {
    setState(() {
      cellColors[newRow][newColumn] = Colors.blue;
      isDragOver[newRow][newColumn] = false;
    });
  }

  void onLeave(isDragOver, newRow, newColumn) {
    setState(() {
      isDragOver[newRow][newColumn] = false;
    });
  }

  bool onWillAccept(isDragOver, newRow, newColumn) {
    setState(() {
      isDragOver[newRow][newColumn] = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: limitingSize / 1.5,
        width: limitingSize / 1.5,
        child: Grid(
          grid: widget.board.grid,
          onTapCell: onTappedCell,
          playerOne: widget.playerOne,
          playerTwo: widget.playerTwo,
        ),
      ),
    );
  }
}
