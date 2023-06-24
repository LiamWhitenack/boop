// import 'player.dart';

import 'package:boop/board.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class Possibility {
  // positive: advantage for player deciding
  // negative: advantage for other player
  late double score;

  // // indicates the player looking at future possibility
  // Player player;

  // int row;
  // int column;
  // String? winner;
  // // ignore: prefer_typing_uninitialized_variables
  // var pieceType;

  // future possibility
  Board futureBoard;

  Player player;
  Player otherPlayer;

  Possibility(
    this.futureBoard,
    this.player,
    this.otherPlayer,
    // this.row,
    // this.column,
    // this.player,
    // this.winner,
    // this.pieceType,
  ) {
    futureBoard.colorGrid = List.filled(6, List.filled(6, Colors.blue.shade200));
    score = scoreFutureGrid();
  }

  // void countAllThreeInARows() {}

  double scoreFutureGrid() {
    return 0.0;
  }
}
