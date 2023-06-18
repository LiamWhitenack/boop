// import 'package:boop/game_flow.dart';
import 'package:boop/kittens_and_cats.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MyGamePage(
          title: 'Boop. Game',
          playerOne: Player('Ralph'),
          playerTwo: Player('Jack'),
          board: Board(),
        ),
        floatingActionButton: Draggable<Kitten>(
          data: Kitten(Player('Ralph')),
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
