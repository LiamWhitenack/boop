List<List> deepCopyMatrix(List<List> matrix) {
  return matrix.map((e) => e.toList()).toList();
}

// List<List> mByNMatrix(int m, int n) {
//   List result = [];
//   for (int i = 0; i < m; i++) {
//     result.add(List.filled(n, null));
//   }
//   return result;
// }
