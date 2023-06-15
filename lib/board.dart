import 'kittens_and_cats.dart';
import 'player.dart';
import 'general_functions.dart';

class Board {
  List<List> grid = List.filled(6, List.filled(6, null));
  late List<List> testGrid = deepCopyMatrix(grid);

  void boopCat(int row, int column, Player player) {}

  void updateGrid() {
    grid = deepCopyMatrix(testGrid);
  }
}
