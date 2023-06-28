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
  ) {
    updateScore();
  }

  void updateScore() {
    double newScore = 0.0;
    scoreFromPositioning = scorePositioning();
    scoreFromPieceProximity = scoreAverageDistanceBetweenPlayersPieces();

    score = newScore + scoreFromPositioning + scoreFromPieceProximity;
  }

  double scorePositioning() {
    Player activePlayer = playerOneTurn ? playerOne : playerTwo;
    double score = 0.0;
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        if (board.tempGrid[row][column] != null) {
          score = score + scoreAffectFromPosition(activePlayer, row, column);
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

  double scoreAverageDistanceBetweenPlayersPieces() {
    int sumDistances = 0;
    int countPlayersPieces = 0;
    int distance;
    int otherSumDistances = 0;
    int otherCountPlayersPieces = 0;
    int otherDistance;
    Player activePlayer = playerOneTurn ? playerOne : playerTwo;
    Player otherPlayer = playerOneTurn ? playerTwo : playerOne;

    for (int i = 0; i < board.tempGrid.length; i++) {
      for (int j = 0; j < board.tempGrid[i].length; j++) {
        if (board.tempGrid[i][j] == null) continue;
        if (board.tempGrid[i][j].player == activePlayer) {
          for (int k = 0; k < board.tempGrid.length; k++) {
            for (int l = 0; l < board.tempGrid[k].length; l++) {
              if (board.tempGrid[k][l] == null) continue;
              if (board.tempGrid[k][l].player == activePlayer) {
                distance = (k - i).abs() > (l - j).abs() ? (k - i).abs() : (l - j).abs();
                sumDistances += distance;
                countPlayersPieces++;
              }
              if (board.tempGrid[k][l].player == otherPlayer) {
                otherDistance = (k - i).abs() > (l - j).abs() ? (k - i).abs() : (l - j).abs();
                otherSumDistances += otherDistance;
                otherCountPlayersPieces++;
              }
            }
          }
        }
      }
    }

    if (countPlayersPieces == 0 && otherCountPlayersPieces == 0) {
      return 0;
    }
    if (otherCountPlayersPieces == 0) {
      return 3 - sumDistances / countPlayersPieces;
    }
    if (countPlayersPieces == 0) {
      return 3 + otherSumDistances / otherCountPlayersPieces;
    }

    return 3 - sumDistances / countPlayersPieces + otherSumDistances / otherCountPlayersPieces;
  }

  double scorePieceIncrease() {
    double score = 0.0;

    return score;
  }

  List<GameState> generateAllFuturePossibilites(GameState gameState) {
    // late Player activePlayerClone;
    // late Player otherPlayerClone;
    List<GameState> result = [];
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        if (gameState.board.tempGrid[row][column] != null) continue;
        if (gameState.board.grid[row][column] != null) continue;
        Player playerOneClone = playerOne.clone();
        Player playerTwoClone = playerTwo.clone();
        Player activePlayer = gameState.playerOneTurn ? playerOneClone : playerTwoClone;

        if (activePlayer.tempCats.isNotEmpty) {
          GameState catGameState = generateFutureGameStateWithCat(
            gameState.board.clone(playerOneClone, playerTwoClone),
            row,
            column,
            activePlayer,
            playerOneTurn,
            winner,
          );

          result.add(catGameState);
        }
        if (activePlayer.tempKittens.isNotEmpty) {
          GameState kittenGameState = generateFutureGameStateWithKitten(
            gameState.board.clone(playerOneClone, playerTwoClone),
            row,
            column,
            activePlayer,
            playerOneTurn,
            winner,
          );

          // kittenGameState.playerOne.tempKittens =
          //     List.filled(kittenGameState.playerOne.tempKittens.length, Kitten(activePlayerClone), growable: true);
          // kittenGameState.playerTwo.tempKittens =
          //     List.filled(kittenGameState.playerTwo.tempKittens.length, Kitten(otherPlayerClone), growable: true);

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
    Player activePlayer,
    bool playerOneTurn,
    String? winner,
  ) {
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // return if the piece isn't placed on an open spot
    if (board.tempGrid[row][column] != null) {
      throw Exception('please place on open spot');
    }

    // return if the player is out of cats to place
    if (activePlayer.tempCats.isEmpty) {
      throw Exception('not enough cats to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        board.boopCatInGivenDirection(row, column, i, j, activePlayer);
      }
    }

    activePlayer.tempCats.removeAt(0);
    board.tempGrid[row][column] = Cat(activePlayer);

    board.updateColorMatrix();
    winner = board.checkForWin();
    board.upgradeThreeInARows();

    return GameState(board, board.playerOne, board.playerTwo, playerOneTurn, winner);
  }

  GameState generateFutureGameStateWithKitten(
    Board board,
    int row,
    int column,
    Player activePlayer,
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
    if (activePlayer.tempKittens.isEmpty) {
      throw Exception('not enough kittens to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        board.boopCatInGivenDirection(row, column, i, j, activePlayer);
      }
    }

    activePlayer.tempKittens.removeAt(0);
    board.tempGrid[row][column] = Kitten(activePlayer);

    winner = board.checkForWin();
    board.upgradeThreeInARows();

    return GameState(board, board.playerOne, board.playerTwo, playerOneTurn, winner);
  }
}
