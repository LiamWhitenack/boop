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
    if (winner != null) return;
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
        playerOne: widget.playerOne,
      ),
    );
  }
}

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
