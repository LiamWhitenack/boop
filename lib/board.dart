import 'kittens_and_cats.dart';
import 'player.dart';
import 'general_functions.dart';

class Board {
  List<List> grid = List.generate(6, (row) => List.filled(6, null));
  late List<List> tempGrid = deepCopyMatrix(grid);
  int? numberOfKittensBelongingToPlayerBeforeTurnStarted;
  int? numberOfCatsBelongingToPlayerBeforeTurnStarted;
  // these are the coordinates that are on the grid
  List<int> validCoordinates = [0, 1, 2, 3, 4, 5];

  void undoLastBoop(Player player) {
    if (numberOfCatsBelongingToPlayerBeforeTurnStarted != null &&
        numberOfKittensBelongingToPlayerBeforeTurnStarted != null) {
      player.kittens = List.filled(numberOfKittensBelongingToPlayerBeforeTurnStarted!, Kitten(player), growable: true);
      player.cats = List.filled(numberOfCatsBelongingToPlayerBeforeTurnStarted!, Cat(player), growable: true);

      tempGrid = deepCopyMatrix(grid);
    }
  }

  void boopCat(int row, int column, Player player) {
    undoLastBoop(player);
    numberOfCatsBelongingToPlayerBeforeTurnStarted = player.cats.length;
    numberOfKittensBelongingToPlayerBeforeTurnStarted = player.kittens.length;

    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      // print('please place on open spot');
      return;
    }

    // return if the player is out of cats to place
    if (player.kittens.isEmpty) {
      // print('not enough cats to place!');
      return;
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        boopCatInGivenDirection(row, column, i, j, player);
      }
    }

    player.cats.removeAt(0);
    tempGrid[row][column] = Cat(player);
  }

  void boopKitten(int row, int column, Player player) {
    undoLastBoop(player);
    numberOfCatsBelongingToPlayerBeforeTurnStarted = player.cats.length;
    numberOfKittensBelongingToPlayerBeforeTurnStarted = player.kittens.length;

    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      // print('please place on open spot');
      return;
    }

    // return if the player is out of kittens to place
    if (player.kittens.isEmpty) {
      // print('not enough kittens to place!');
      return;
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        boopKittenInGivenDirection(row, column, i, j, player);
      }
    }

    // print("64");
    player.kittens.removeAt(0);
    tempGrid[row][column] = Kitten(player);
  }

  void boopCatInGivenDirection(int row, int column, int i, int j, Player player) {
    Player? ownerOfBoopedPiece;
    // if there is a piece neighboring the piece, "boop" it away
    if (grid[row + i][column + j] != null) {
      ownerOfBoopedPiece = grid[row + i][column + j].player;
      // if the piece is being moved off the edge, give it back to its owner
      if (!validCoordinates.contains(row + i + i) || !validCoordinates.contains(column + j + j)) {
        if (grid[row + i][column + j] is Kitten) {
          player.kittens.add(Kitten(ownerOfBoopedPiece!));
          // numberOfKittensToReturnIfMoveIsTakenBack++;
        } else {
          player.cats.add(Cat(ownerOfBoopedPiece!));
          // numberOfCatsToReturnIfMoveIsTakenBack++;
        }

        tempGrid[row + i][column + j] = null;
        return;
      }
      // unless the position it is being moved into isn't empty
      if (grid[row + i + i][column + j + j] != null) {
        return;
      } // if the piece can be "booped" into an empty space, "boop" it
      else {
        if (grid[row + i][column + j] is Kitten) {
          tempGrid[row + i + i][column + j + j] = Kitten(ownerOfBoopedPiece!);
        } else {
          tempGrid[row + i + i][column + j + j] = Cat(ownerOfBoopedPiece!);
        }

        tempGrid[row + i][column + j] = null;
      }
    }
  }

  void boopKittenInGivenDirection(int row, int column, int i, int j, Player player) {
    Player? ownerOfBoopedPiece;

    // if there is a kitten neighboring the piece, "boop" it away
    if (grid[row + i][column + j] is Kitten) {
      ownerOfBoopedPiece = grid[row + i][column + j].player;
      // if the kitten is being moved off the edge, give it back to its owner
      if (!validCoordinates.contains(row + i + i) || !validCoordinates.contains(column + j + j)) {
        player.kittens.add(Kitten(ownerOfBoopedPiece!));
        // numberOfKittensToReturnIfMoveIsTakenBack++;

        tempGrid[row + i][column + j] = null;
        return;
      }
      // unless the position it is being moved into isn't empty
      if (grid[row + i + i][column + j + j] != null) {
        return;
      } // if the piece can be "booped" into an empty space, "boop" it
      else {
        tempGrid[row + i + i][column + j + j] = Kitten(ownerOfBoopedPiece!);
        tempGrid[row + i][column + j] = null;
      }
    }
  }

  bool cellGoingToBeChangedOnUpdate(int row, int column) {
    return tempGrid[row][column] != grid[row][column];
  }

  void updateGrid() {
    grid = deepCopyMatrix(tempGrid);
    numberOfCatsBelongingToPlayerBeforeTurnStarted = null;
    numberOfKittensBelongingToPlayerBeforeTurnStarted = null;
  }

  bool checkIfAllPiecesBelongToTheSamePlayer(List<List<int>> coordinates) {
    int row;
    int column;
    Player? owner;
    for (List<int> coordinate in coordinates) {
      row = coordinate[0];
      column = coordinate[1];
      if (tempGrid[row][column] == null) {
        return false;
      }
      if (owner == null) {
        owner = tempGrid[row][column].player;
      } else if (tempGrid[row][column].player != owner) {
        return false;
      }
    }
    return true;
  }

  List<List<List<int>>> findAllThreeInARow() {
    List<List<List<int>>> allCoordinates = [];

    // WARNING: This code was generated by ChatGPT and could easily have some errors although the code looks pretty good

    // Check rows
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 4; column++) {
        if (checkIfAllPiecesBelongToTheSamePlayer([
          [row, column],
          [row, column + 1],
          [row, column + 2]
        ])) {
          List<List<int>> coordinates = [];
          for (int i = 0; i < 3; i++) {
            coordinates.add([row, column + i]);
          }
          allCoordinates.add(coordinates);
        }
      }
    }

    // Check columns
    for (int column = 0; column < 6; column++) {
      for (int row = 0; row < 4; row++) {
        if (checkIfAllPiecesBelongToTheSamePlayer([
          [row, column],
          [row + 1, column],
          [row + 2, column]
        ])) {
          List<List<int>> coordinates = [];
          for (int i = 0; i < 3; i++) {
            coordinates.add([row + i, column]);
          }
          allCoordinates.add(coordinates);
        }
      }
    }

    // Check diagonals (top-left to bottom-right)
    for (int row = 0; row < 4; row++) {
      for (int column = 0; column < 4; column++) {
        if (checkIfAllPiecesBelongToTheSamePlayer([
          [row, column],
          [row + 1, column + 1],
          [row + 2, column + 2]
        ])) {
          List<List<int>> coordinates = [];
          for (int i = 0; i < 3; i++) {
            coordinates.add([row + i, column + i]);
          }
          allCoordinates.add(coordinates);
        }
      }
    }

    // Check diagonals (top-right to bottom-left)
    for (int row = 0; row < 4; row++) {
      for (int column = 2; column < 6; column++) {
        if (checkIfAllPiecesBelongToTheSamePlayer([
          [row, column],
          [row + 1, column - 1],
          [row + 2, column - 2]
        ])) {
          List<List<int>> coordinates = [];
          for (int i = 0; i < 3; i++) {
            coordinates.add([row + i, column - i]);
          }
          allCoordinates.add(coordinates);
        }
      }
    }

    return allCoordinates;
  }

  String? checkForWin() {
    int numberOfCatsInARow = 0;
    List<List<List<int>>> allThreeInARowCoordinates = findAllThreeInARow();
    for (List<List<int>> threeInARowCoordinates in allThreeInARowCoordinates) {
      for (List<int> coordinate in threeInARowCoordinates) {
        int row = coordinate[0];
        int column = coordinate[1];
        if (tempGrid[row][column] is Cat) {
          numberOfCatsInARow++;
        } else {
          break;
        }
        if (numberOfCatsInARow == 3) {
          return tempGrid[row][column].player.name;
        }
      }
    }
    return null;
  }

  void upgradeThreeInARows() {
    List<List<List<int>>> allThreeInARowCoordinates = findAllThreeInARow();
    for (List<List<int>> threeInARowCoordinates in allThreeInARowCoordinates) {
      for (List<int> coordinates in threeInARowCoordinates) {
        int row = coordinates[0];
        int column = coordinates[1];

        grid[row][column].player.cats.add(Cat(grid[row][column].player));
        grid[row][column] = null;
      }
    }
    tempGrid = deepCopyMatrix(grid);
  }
}
