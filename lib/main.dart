import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';

void main() {
  // playGame();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boop.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Boop. Game',
        playerOne: Player('Ralph'),
        playerTwo: Player('Jack'),
        board: Board(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // used to alternate turns
  bool playerOneTurn = true;

  // this variable is null if there is no winner yet, else their name
  String? winner;

  // these are user inputs
  String? pieceType;
  int? row;
  int? column;

  void onTappedCell(int newRow, int newColumn) {
    setState(() {
      print('piece at $newRow, $newColumn was tapped');
      row = newRow;
      column = newColumn;
      pieceType = 'Kitten';
      takeTurn(widget.board, widget.playerOne, widget.playerTwo, pieceType!, row!, column!);
      // print(widget.board.tempGrid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Grid(
        grid: widget.board.grid,
        onTapCell: onTappedCell,
      ),
    );
  }
}

class Grid extends StatelessWidget {
  final List<List<dynamic>> grid;
  final Function(int, int) onTapCell;

  const Grid({super.key, required this.grid, required this.onTapCell});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: grid.length * grid[0].length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: grid[0].length,
      ),
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ grid[0].length;
        int col = index % grid[0].length;
        bool isNull = grid[row][col] == null;
        Color cellColor = isNull ? Colors.red : Colors.blue;
        return GestureDetector(
          onTap: () {
            onTapCell(row, col);
          },
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                grid[row][col]?.toString() ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
