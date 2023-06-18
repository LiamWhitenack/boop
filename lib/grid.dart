import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'kittens_and_cats.dart';

class Grid extends StatefulWidget {
  final List<List<dynamic>> grid;
  final Function(int, int) onTapCell;
  final Player playerOne;
  final Player playerTwo;

  const Grid({
    super.key,
    required this.grid,
    required this.onTapCell,
    required this.playerOne,
    required this.playerTwo,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<List<bool>> isDragOver = List.generate(6, (row) => List.filled(6, true));

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
    return GridView.builder(
      itemCount: 36,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.grid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ widget.grid[0].length;
        int column = index % widget.grid[0].length;
        Color cellColor = getCellColor(widget.grid[row][column], widget.playerOne);
        return DragTarget<int>(
          onAccept: (value) {
            setState(() {
              widget.grid[row][column] = Kitten(widget.playerOne);
              isDragOver[row][column] = false;
            });
          },
          onLeave: (value) {
            setState(() {
              widget.grid[row][column] = null;
              isDragOver[row][column] = false;
            });
          },
          onWillAccept: (value) {
            setState(() {
              isDragOver[row][column] = true;
            });
            return true;
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () {
                widget.onTapCell(row, column);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    widget.grid[row][column]?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
