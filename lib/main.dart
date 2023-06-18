import 'package:boop/game_flow.dart';
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
      home: MyGamePage(
        title: 'Boop. Game',
        playerOne: Player('Ralph'),
        playerTwo: Player('Jack'),
        board: Board(),
      ),
    );
  }
}
