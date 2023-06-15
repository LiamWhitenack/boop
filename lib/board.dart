import 'kittens_and_cats.dart';
import 'player.dart';
import 'general_functions.dart';

class Board {
  List<List> grid = List.filled(6, List.filled(6, null));
  late List<List> testGrid = deepCopyMatrix(grid);

  void boopCat(int row, int column, Player player) {
    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      return;
    }

    // these are the coordinates that are on the grid
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        boopCatInGivenDirection(row, column, i, j, player);
      }
    }

    grid[row][column] = Cat(player);
  }

  void boopKitten(int row, int column, Player player) {
    // return if the piece isn't placed on an open spot
    if (grid[row][column] != null) {
      return;
    }

    // these are the coordinates that are on the grid
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!validCoordinates.contains(row + i) || !validCoordinates.contains(column + j)) {
          continue;
        }
        boopKittenInGivenDirection(row, column, i, j, player);
      }
    }

    grid[row][column] = Cat(player);
  }

  void boopCatInGivenDirection(int row, int column, int i, int j, Player player) {
    // these are the coordinates that are on the grid
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // ignore the coordinates that are not on the grid

    // if there is a piece neighboring the piece, "boop" it away
    if (grid[row + i][column + j] != null) {
      // if the piece is being moved off the edge, give it back to its owner
      if (!validCoordinates.contains(row + i + i) || !validCoordinates.contains(column + j + j)) {
        if (grid[row + i][column + j] is Kitten) {
          player.kittens.add(Kitten(player));
        } else {
          player.cats.add(Cat(player));
        }

        grid[row + i][column + j] = null;
      }
      // unless the position it is being moved into isn't empty
      if (grid[row + i + i][column + j + j] != null) {
        return;
      } // if the piece can be "booped" into an empty space, "boop" it
      else {
        if (grid[row + i][column + j] is Kitten) {
          grid[row + i + i][column + j + j] = Kitten(player);
        } else {
          grid[row + i + i][column + j + j] = Cat(player);
        }

        grid[row + i][column + j] = null;
      }
    }
  }

  void boopKittenInGivenDirection(int row, int column, int i, int j, Player player) {
    // these are the coordinates that are on the grid
    List<int> validCoordinates = [0, 1, 2, 3, 4, 5];
    // ignore the coordinates that are not on the grid

    // if there is a kitten neighboring the piece, "boop" it away
    if (grid[row + i][column + j] is Kitten) {
      // if the kitten is being moved off the edge, give it back to its owner
      if (!validCoordinates.contains(row + i + i) || !validCoordinates.contains(column + j + j)) {
        player.kittens.add(Kitten(player));

        grid[row + i][column + j] = null;
      }
      // unless the position it is being moved into isn't empty
      if (grid[row + i + i][column + j + j] != null) {
        return;
      } // if the piece can be "booped" into an empty space, "boop" it
      else {
        if (grid[row + i][column + j] is Kitten) {
          grid[row + i + i][column + j + j] = Kitten(player);
        } else {
          grid[row + i + i][column + j + j] = Cat(player);
        }

        grid[row + i][column + j] = null;
      }
    }
  }

  void updateGrid() {
    grid = deepCopyMatrix(testGrid);
  }

  Player? checkForWin() {
    return null;
  }
}
