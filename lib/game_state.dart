// import 'playerOne.dart';

import 'package:boop/board.dart';
import 'kittens_and_cats.dart';
import 'player.dart';

class GameState {
  // positive: advantage for playerOne deciding
  // negative: advantage for other playerOne
  double score = 0.0;
  late double scoreFromPositioning = 0.0;
  late double scoreFromPieceProximity = 0.0;
  late double scoreFromTwoInARows = 0.0;
  late double scoreFromUpgrading = 0.0;
  late double scoreFromWinning = 0.0;

  // future possibility
  Board board;

  Player playerOne;
  Player playerTwo;
  late Player activePlayer;
  late Player otherPlayer;

  bool playerOneTurn;

  bool gameOver = false;

  GameState(
    this.board,
    this.playerOne,
    this.playerTwo,
    this.playerOneTurn,
  ) {
    // updateScore();
    updateActivePlayer();
  }

  void updateActivePlayer() {
    activePlayer = playerOneTurn ? playerOne : playerTwo;
    otherPlayer = playerOneTurn ? playerTwo : playerOne;
  }

  void updateValues() {
    board.updateGrid();
    playerOne.updateKittensAndCats();
    playerTwo.updateKittensAndCats();
  }

  void updateScore() {
    scoreFromPositioning = scorePositioning();
    scoreFromPieceProximity = scoreAverageDistanceBetweenPlayersPieces();
    scoreFromTwoInARows = scoreTwoInARows();
    scoreFromUpgrading = scorePieceIncrease();
    scoreFromWinning = scoreWinPotential();

    score =
        scoreFromPositioning + scoreFromPieceProximity + scoreFromTwoInARows + scoreFromUpgrading + scoreFromWinning;
  }

  double scorePositioning() {
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

  double scoreTwoInARows() {
    Map<Player, double> counts = {activePlayer: 0, otherPlayer: 0};
    Player tempPlayer;

    // Check rows
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 5; column++) {
        if (board.tempGrid[row][column] == null) continue;
        if (board.tempGrid[row][column + 1] == null) continue;
        tempPlayer = board.tempGrid[row][column].player;
        if (tempPlayer == board.tempGrid[row][column + 1].player) {
          counts[tempPlayer] = counts[tempPlayer]! + 1;
        }
      }
    }

    // Check columns
    for (int column = 0; column < 6; column++) {
      for (int row = 0; row < 5; row++) {
        if (board.tempGrid[row][column] == null) continue;
        if (board.tempGrid[row + 1][column] == null) continue;
        tempPlayer = board.tempGrid[row][column].player;
        if (tempPlayer == board.tempGrid[row + 1][column].player) {
          counts[tempPlayer] = counts[tempPlayer]! + 1;
        }
      }
    }

    // Check diagonals (top-left to bottom-right)
    for (int row = 0; row < 5; row++) {
      for (int column = 0; column < 5; column++) {
        if (board.tempGrid[row][column] == null) continue;
        if (board.tempGrid[row + 1][column + 1] == null) continue;
        tempPlayer = board.tempGrid[row][column].player;
        if (tempPlayer == board.tempGrid[row + 1][column + 1].player) {
          counts[tempPlayer] = counts[tempPlayer]! + 1;
        }
      }
    }

    // Check diagonals (top-right to bottom-left)
    for (int row = 0; row < 4; row++) {
      for (int column = 1; column < 6; column++) {
        if (board.tempGrid[row][column] == null) continue;
        if (board.tempGrid[row + 1][column - 1] == null) continue;
        tempPlayer = board.tempGrid[row][column].player;
        if (tempPlayer == board.tempGrid[row + 1][column - 1].player) {
          counts[tempPlayer] = counts[tempPlayer]! + 1;
        }
      }
    }
    return 2 * (counts[activePlayer]! - counts[otherPlayer]!);
  }

  double scorePieceIncrease() {
    double score = 0.0;
    score = score + 3 * (activePlayer.tempCats.length - activePlayer.cats.length);
    score = score - 3 * (otherPlayer.tempCats.length - otherPlayer.cats.length);
    score = score + (activePlayer.tempKittens.length - activePlayer.kittens.length);
    score = score - (otherPlayer.tempKittens.length - otherPlayer.kittens.length);

    return score;
  }

  double scoreWinPotential() {
    double score = 0.0;

    // winner = board.checkForWin();
    if (board.winner == activePlayer.name) {
      score = score + 9999;
    }
    if (board.winner == otherPlayer.name) {
      score = score - 9999;
    }

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

        if (activePlayer.tempCats.isNotEmpty) {
          GameState catGameState = generateFutureGameStateWithCat(row, column);
          catGameState.updateScore();
          catGameState.updateValues();
          catGameState.playerOneTurn = !catGameState.playerOneTurn;
          catGameState.updateActivePlayer();
          result.add(catGameState);
        }
        if (activePlayer.tempKittens.isNotEmpty) {
          GameState kittenGameState = generateFutureGameStateWithKitten(row, column);
          kittenGameState.updateScore();
          kittenGameState.updateValues();
          kittenGameState.playerOneTurn = !kittenGameState.playerOneTurn;
          kittenGameState.updateActivePlayer();
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
    int row,
    int column,
  ) {
    Board newBoard = board.clone(playerOne, playerTwo);
    Player tempActivePlayer = playerOneTurn ? newBoard.playerOne : newBoard.playerTwo;

    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // return if the piece isn't placed on an open spot
    if (board.tempGrid[row][column] != null) {
      throw Exception('please place on open spot');
    }

    // return if the player is out of cats to place
    if (tempActivePlayer.tempCats.isEmpty) {
      throw Exception('not enough cats to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        newBoard.boopCatInGivenDirection(row, column, i, j, tempActivePlayer);
      }
    }

    tempActivePlayer.tempCats.removeAt(0);
    newBoard.tempGrid[row][column] = Cat(tempActivePlayer);

    newBoard.updateColorMatrix();
    newBoard.checkForWin();
    newBoard.upgradeThreeInARows();

    GameState result = GameState(newBoard, newBoard.playerOne, newBoard.playerTwo, playerOneTurn);

    return result;
  }

  GameState generateFutureGameStateWithKitten(
    int row,
    int column,
  ) {
    Board newBoard = board.clone(playerOne, playerTwo);
    Player tempActivePlayer = playerOneTurn ? newBoard.playerOne : newBoard.playerTwo;

    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // return if the piece isn't placed on an open spot
    if (board.tempGrid[row][column] != null) {
      throw Exception('please place on open spot');
    }

    // return if the player is out of cats to place
    if (tempActivePlayer.tempKittens.isEmpty) {
      throw Exception('not enough kittens to place!');
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        newBoard.boopKittenInGivenDirection(row, column, i, j, tempActivePlayer);
      }
    }

    tempActivePlayer.tempKittens.removeAt(0);
    newBoard.tempGrid[row][column] = Kitten(tempActivePlayer);

    newBoard.updateColorMatrix();
    newBoard.checkForWin();
    newBoard.upgradeThreeInARows();

    GameState result = GameState(newBoard, newBoard.playerOne, newBoard.playerTwo, playerOneTurn);

    return result;
  }

  void conform(GameState gameState) {
    board = gameState.board;
    playerOne = gameState.playerOne;
    playerTwo = gameState.playerTwo;
    playerOneTurn = gameState.playerOneTurn;
    updateActivePlayer();
  }

  GameState clone() {
    Player playerOneClone = playerOne.clone();
    Player playerTwoClone = playerTwo.clone();
    return GameState(
      board.clone(playerOneClone, playerTwoClone),
      playerOneClone,
      playerTwoClone,
      playerOneTurn,
    );
  }
}
