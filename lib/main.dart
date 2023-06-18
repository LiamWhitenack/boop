// import 'package:boop/game_flow.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'my_game_page.dart';

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
      home: Scaffold(
        body: MyGamePage(
          title: 'Boop. Game',
          playerOne: Player('Ralph'),
          playerTwo: Player('Jack'),
          board: Board(),
        ),
        floatingActionButton: Draggable<int>(
          data: 1,
          feedback: FloatingActionButton(
            child: const Icon(Icons.ac_unit),
            onPressed: () {},
          ),
          child: FloatingActionButton(
            child: const Icon(Icons.ac_unit),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class GridDragApp extends StatefulWidget {
  @override
  _GridDragAppState createState() => _GridDragAppState();
}

class _GridDragAppState extends State<GridDragApp> {
  late List<Color> cellColors;
  late List<bool> isDragOver;

  @override
  void initState() {
    super.initState();
    cellColors = List.filled(25, Colors.red);
    isDragOver = List.filled(25, false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Grid Drag'),
        ),
        body: GridView.builder(
          itemCount: 25,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return DragTarget<int>(
              onAccept: (value) {
                setState(() {
                  cellColors[index] = Colors.blue;
                  isDragOver[index] = false;
                });
              },
              onLeave: (value) {
                setState(() {
                  isDragOver[index] = false;
                });
              },
              onWillAccept: (value) {
                setState(() {
                  isDragOver[index] = true;
                });
                return true;
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  color: isDragOver[index] ? Colors.blue : cellColors[index],
                  height: 50,
                  width: 50,
                );
              },
            );
          },
        ),
        floatingActionButton: Draggable<int>(
          data: 1,
          feedback: FloatingActionButton(
            child: const Icon(Icons.ac_unit),
            onPressed: () {},
          ),
          child: FloatingActionButton(
            child: const Icon(Icons.ac_unit),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
