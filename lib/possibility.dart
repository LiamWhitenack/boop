// import 'player.dart';

import 'package:boop/board.dart';

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

  int myKittens;
  int myCats;

  int theirKittens;
  int theirCats;

  Possibility(
    this.futureBoard,
    this.myKittens,
    this.myCats,
    this.theirKittens,
    this.theirCats,
    // this.row,
    // this.column,
    // this.player,
    // this.winner,
    // this.pieceType,
  ) {
    score = scoreFutureGrid();
  }

  void countAllThreeInARows() {}

  double scoreFutureGrid() {
    return 0.0;
  }
}
