// import 'player.dart';

import 'package:boop/board.dart';
import 'kittens_and_cats.dart';
import 'player.dart';

class Possibility {
  // positive: advantage for player deciding
  // negative: advantage for other player
  double score = 0.0;

  // // indicates the player looking at future possibility
  // Player player;

  // int row;
  // int column;
  // String? winner;
  // // ignore: prefer_typing_uninitialized_variables
  // var pieceType;

  // future possibility
  Board board;

  Player player;
  Player otherPlayer;

  Possibility(
    this.board,
    this.player,
    this.otherPlayer,
    // this.row,
    // this.column,
    // this.player,
    // this.winner,
    // this.pieceType,
  );

  void updateScore() {
    score = scoreGrid();
  }

  double scoreGrid() {
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        if (board.tempGrid[row][column] != null) {
          score = score + scoreAffectFromPosition(player, row, column);
        }
      }
    }
    return score;
  }

  double scoreAffectFromPosition(Player player, int row, int column) {
    double distanceFromCenter = (row.toDouble() - 2.5).abs() + (column.toDouble() - 2.5).abs();
    double pointsForCloseness = 3 - distanceFromCenter;
    if (board.tempGrid[row][column].player != player) {
      // lose points for the other player's pieces being in the center else gain points
      pointsForCloseness = -pointsForCloseness;
    }

    // return double points for cats
    return (board.tempGrid[row][column] is Cat) ? pointsForCloseness * 2 : pointsForCloseness;
  }
}
