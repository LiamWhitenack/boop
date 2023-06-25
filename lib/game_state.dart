// import 'playerOne.dart';

import 'package:boop/board.dart';
import 'kittens_and_cats.dart';
import 'player.dart';

class GameState {
  // positive: advantage for playerOne deciding
  // negative: advantage for other playerOne
  double score = 0.0;
  late double scoreFromPositioning;
  late double scoreFromPieceProximity;
  late double scoreFromUpgrading;
  late double scoreFromWinning;

  // future possibility
  Board board;

  Player playerOne;
  Player playerTwo;

  bool playerOneTurn;

  String? winner;

  GameState(
    this.board,
    this.playerOne,
    this.playerTwo,
    this.playerOneTurn,
    this.winner,
    // this.row,
    // this.column,
    // this.playerOne,
    // this.winner,
    // this.pieceType,
  );

  void updateScore() {
    double newScore = 0.0;
    scoreFromPositioning = scorePositioning();

    score = newScore + scoreFromPositioning;
  }

  double scorePositioning() {
    double score = 0.0;
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        if (board.tempGrid[row][column] != null) {
          score = score + scoreAffectFromPosition(playerOne, row, column);
        }
      }
    }
    return score;
  }

  double scoreAffectFromPosition(Player playerOne, int row, int column) {
    double distanceFromCenter = (row.toDouble() - 2.5).abs() + (column.toDouble() - 2.5).abs();
    double pointsForCloseness = 3 - distanceFromCenter;
    if (board.tempGrid[row][column].player != playerOne) {
      // lose points for the other playerOne's pieces being in the center else gain points
      pointsForCloseness = -pointsForCloseness;
    }

    // return double points for cats
    return (board.tempGrid[row][column] is Cat) ? pointsForCloseness * 2 : pointsForCloseness;
  }

  List<GameState> generateAllFuturePossibilites(GameState gameState) {
    // late Player playerClone;
    // late Player otherPlayerClone;
    List<GameState> result = [];
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        if (gameState.board.tempGrid[row][column] != null) continue;
        if (gameState.board.grid[row][column] != null) continue;
        Player playerClone = playerOne.clone();
        Player otherPlayerClone = playerTwo.clone();
        if (playerOne.tempCats.isNotEmpty) {
          GameState catGameState = generateFutureGameStateWithCat(gameState.board.clone(playerClone, otherPlayerClone),
              row, column, playerClone, otherPlayerClone, playerOneTurn, winner);
          catGameState.playerOne.tempCats =
              List.filled(catGameState.playerOne.tempKittens.length, Cat(playerClone), growable: true);
          catGameState.playerTwo.tempCats =
              List.filled(catGameState.playerTwo.tempKittens.length, Cat(otherPlayerClone), growable: true);
          catGameState.updateScore();
          result.add(catGameState);
        }
        if (playerOne.tempKittens.isNotEmpty) {
          GameState kittenGameState = generateFutureGameStateWithKitten(
              gameState.board.clone(playerClone, otherPlayerClone),
              row,
              column,
              playerClone,
              otherPlayerClone,
              playerOneTurn,
              winner);

          kittenGameState.playerOne.tempKittens =
              List.filled(kittenGameState.playerOne.tempKittens.length, Kitten(playerClone), growable: true);
          kittenGameState.playerTwo.tempKittens =
              List.filled(kittenGameState.playerTwo.tempKittens.length, Kitten(otherPlayerClone), growable: true);
          kittenGameState.updateScore();

          result.add(kittenGameState);
        }
      }
    }
    return sortGameStates(result);
  }

  List<GameState> sortGameStates(List<GameState> list) {
    list.sort((a, b) => a.score.compareTo(b.score));
    return list.reversed.toList();
  }

  GameState generateFutureGameStateWithCat(
    Board board,
    int row,
    int column,
    Player playerClone,
    Player otherPlayerClone,
    bool playerOneTurn,
    String? winner,
  ) {
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // return if the piece isn't placed on an open spot
    if (board.tempGrid[row][column] != null) {
      throw Exception('please place on open spot');
    }

    // return if the player is out of cats to place
    if (playerClone.tempCats.isEmpty) {
      throw Exception('not enough cats to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        board.boopCatInGivenDirection(row, column, i, j, playerClone);
      }
    }

    playerClone.tempCats.removeAt(0);
    board.tempGrid[row][column] = Cat(playerClone);

    board.updateColorMatrix();
    winner = board.checkForWin();
    board.upgradeThreeInARows();

    return GameState(
      board,
      playerClone,
      otherPlayerClone,
      playerOneTurn,
      winner,
    );
  }

  GameState generateFutureGameStateWithKitten(
    Board board,
    int row,
    int column,
    Player playerClone,
    Player otherPlayerClone,
    bool playerOneTurn,
    String? winner,
  ) {
    board.undoLastBoop();

    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];

    // return if the piece isn't placed on an open spot
    if (board.tempGrid[row][column] != null) {
      throw Exception('please place on open spot');
    }

    // return if the player is out of cats to place
    if (playerClone.tempKittens.isEmpty) {
      throw Exception('not enough kittens to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        board.boopCatInGivenDirection(row, column, i, j, playerClone);
      }
    }

    playerClone.tempKittens.removeAt(0);
    board.tempGrid[row][column] = Kitten(playerClone);

    winner = board.checkForWin();
    board.upgradeThreeInARows();

    return GameState(board, playerClone, otherPlayerClone, playerOneTurn, winner);
  }
}
