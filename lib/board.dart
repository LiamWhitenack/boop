import 'kittens_and_cats.dart';
import 'player.dart';
import 'general_functions.dart';

class Board {
  List<List> grid = List.generate(6, (row) => List.filled(6, null));
  late List<List> tempGrid = deepCopyMatrix(grid);
  // these are the coordinates that are on the grid
  List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
  Player playerOne;
  Player playerTwo;
  Board(this.playerOne, this.playerTwo);

  void setUpPlayerForWinning(Player player) {
    // this function is for testing only

    grid[0][0] = Cat(player);
    grid[0][1] = Cat(player);
    grid[2][0] = Cat(player);
    grid[2][1] = Cat(player);
    grid[4][0] = Cat(player);
    grid[4][1] = Cat(player);
    grid[5][5] = Cat(player);
    // grid[1][3] = Cat(player);
  }

  void reset() {
    grid = List.generate(6, (row) => List.filled(6, null));
    tempGrid = deepCopyMatrix(grid);
  }

  void undoLastBoop() {
    for (Player player in getPlayers()) {
      player.revertKittensAndCats();
    }
    tempGrid = deepCopyMatrix(grid);
  }

  void boopCat(int row, int column, Player player) {
    undoLastBoop();

    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      print('please place on open spot');
      return;
    }

    // return if the player is out of cats to place
    if (player.tempCats.isEmpty) {
      print('not enough cats to place!');
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

    player.tempCats.removeAt(0);
    tempGrid[row][column] = Cat(player);

    upgradeThreeInARows();
  }

  void boopKitten(int row, int column, Player player) {
    undoLastBoop();

    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      print('please place on open spot');
      return;
    }

    // return if the player is out of kittens to place
    if (player.kittens.isEmpty) {
      print('not enough kittens to place!');
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
    player.tempKittens.removeAt(0);
    tempGrid[row][column] = Kitten(player);

    upgradeThreeInARows();
  }

  void boopCatInGivenDirection(int row, int column, int i, int j, Player player) {
    Player? ownerOfBoopedPiece;
    // if there is a piece neighboring the piece, "boop" it away
    if (grid[row + i][column + j] != null) {
      ownerOfBoopedPiece = grid[row + i][column + j].player;
      // if the piece is being moved off the edge, give it back to its owner
      if (!validCoordinates.contains(row + i + i) || !validCoordinates.contains(column + j + j)) {
        if (grid[row + i][column + j] is Kitten) {
          ownerOfBoopedPiece!.tempKittens.add(Kitten(ownerOfBoopedPiece));
          // numberOfKittensToReturnIfMoveIsTakenBack++;
        } else {
          ownerOfBoopedPiece!.tempCats.add(Cat(ownerOfBoopedPiece));
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
        ownerOfBoopedPiece!.tempKittens.add(Kitten(ownerOfBoopedPiece));
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

  bool listOfCoordinateContainsCoordinate(List<List<int>> coordinates, List<int> coordinate) {
    for (List<int> item in coordinates) {
      if (item[0] == coordinate[0] && item[1] == coordinate[1]) {
        return true;
      }
    }
    return false;
  }

  List<List<List<int>>> removeDuplicateCoordinates(List<List<List<int>>> inputList) {
    List<List<int>> result = [];
    // [[[1,1],[2,3],[3,3]], [[2,3],[3,3],[4,4]], [[3,3],[4,4],[5,5]]] to [[[1,1],[2,3],[3,3],[4,4],[5,5]]]

    for (List<List<int>> threeInARow in inputList) {
      for (List<int> coordinate in threeInARow) {
        if (!listOfCoordinateContainsCoordinate(result, coordinate)) {
          result.add(coordinate);
        }
      }
    }

    return [result];
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

    return removeDuplicateCoordinates(allCoordinates);
  }

  List<Player> getPlayers() {
    return [playerOne, playerTwo];
  }

  String? eightCatsOnGrid() {
    List<Player> players = getPlayers();
    if (players.isEmpty) return null;
    if (players.length == 1) {
      Player player1 = players[0];
      bool player1HasKittens = player1.tempKittens.isNotEmpty;
      bool player1HasCats = player1.tempCats.isNotEmpty;
      if (player1HasKittens || player1HasCats) {
        return null;
      } else {
        return doesPlayerHaveEightCatsOnGrid(player1) ? player1.name : null;
      }
    }
    Player player1 = players[0];
    Player player2 = players[1];
    bool player1HasKittens = player1.tempKittens.isNotEmpty;
    bool player1HasCats = player1.tempCats.isNotEmpty;
    bool player2HasKittens = player2.tempKittens.isNotEmpty;
    bool player2HasCats = player2.tempCats.isNotEmpty;
    if ((player1HasKittens || player1HasCats) && (player2HasKittens || player2HasCats)) {
      return null;
    } else if (player1HasKittens || player1HasCats) {
      return doesPlayerHaveEightCatsOnGrid(player2) ? player2.name : null;
    } else if (player2HasKittens || player2HasCats) {
      return doesPlayerHaveEightCatsOnGrid(player1) ? player1.name : null;
    }
    // this shouldn't EVER happen
    return null;
  }

  bool doesPlayerHaveEightCatsOnGrid(Player player) {
    int numberOfCats = 0;
    for (int row = 0; row < 6; row++) {
      for (int column = 0; column < 6; column++) {
        var cell = tempGrid[row][column];
        if (cell == null) {
          continue;
        }
        if (cell is Kitten) {
          return false;
        } else if (cell is Cat) {
          numberOfCats++;
          if (numberOfCats == 8) {
            return true;
          }
        }
      }
    }
    // this shouldn't ever happen
    return false;
  }

  String? checkForWin() {
    int numberOfCatsInARow = 0;
    String? winnerFromHavingEightCats = eightCatsOnGrid();
    if (winnerFromHavingEightCats != null) {
      return winnerFromHavingEightCats;
    }
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

        tempGrid[row][column].player.tempCats.add(Cat(tempGrid[row][column].player));
        tempGrid[row][column] = null;
      }
    }
    // tempGrid = deepCopyMatrix(grid);
  }
}
