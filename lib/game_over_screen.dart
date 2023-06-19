import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final String winner;
  final Function startOver;
  const GameOverScreen({
    super.key,
    required this.winner,
    required this.startOver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: const Text(
          'Game Over!',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              '$winner Wins!',
              style: const TextStyle(color: Colors.white, fontSize: 95),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  startOver();
                }, // startOver(),
                child: const Text('Play Again'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
