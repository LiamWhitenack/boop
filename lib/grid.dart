import 'package:boop/player.dart';
import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final List<List<dynamic>> grid;
  final Function(int, int) onTapCell;
  final Player playerOne;

  const Grid({
    super.key,
    required this.grid,
    required this.onTapCell,
    required this.playerOne,
  });

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
      itemCount: grid.length * grid[0].length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: grid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ grid[0].length;
        int column = index % grid[0].length;
        Color cellColor = getCellColor(grid[row][column], playerOne);
        return GestureDetector(
          onTap: () {
            onTapCell(row, column);
          },
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                grid[row][column]?.toString() ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
