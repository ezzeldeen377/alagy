void main() {
  Solution().solveNQueens(4);
}

class Solution {
  List<List<String>> solveNQueens(int n) {
    List<List<String>> matrix = List.generate(
      n,
      (_) => List.generate(n, (_) => '', growable: false),
      growable: false,
    );

    int queensToPlace = n;

    for (int k = 0; k < n * n; k++) {
      int i = k ~/ n;
      int j = k % n;

      // If the cell is empty, try placing a queen
      if (matrix[i][j].isEmpty) {
        matrix[i][j] = 'Q';
        queensToPlace--;

        // Mark row, column, and diagonals
        for (int x = 0; x < n; x++) {
          if (matrix[i][x].isEmpty) matrix[i][x] = '.';
          if (matrix[x][j].isEmpty) matrix[x][j] = '.';

          // Diagonal from top-left to bottom-right
          int d1Row = i - x;
          int d1Col = j - x;
          int d2Row = i - x;
          int d2Col = j + x;
          int d3Row = i + x;
          int d3Col = j - x;
          int d4Row = i + x;
          int d4Col = j + x;

          if (_isInBounds(d1Row, d1Col, n) && matrix[d1Row][d1Col].isEmpty) {
            matrix[d1Row][d1Col] = '.';
          }
          if (_isInBounds(d2Row, d2Col, n) && matrix[d2Row][d2Col].isEmpty) {
            matrix[d2Row][d2Col] = '.';
          }
          if (_isInBounds(d3Row, d3Col, n) && matrix[d3Row][d3Col].isEmpty) {
            matrix[d3Row][d3Col] = '.';
          }
          if (_isInBounds(d4Row, d4Col, n) && matrix[d4Row][d4Col].isEmpty) {
            matrix[d4Row][d4Col] = '.';
          }
        }

        if (queensToPlace == 0) {
          break;
        }
      }
    }

    _printMatrix(matrix);
    return matrix;
  }

  bool _isInBounds(int i, int j, int n) {
    return i >= 0 && i < n && j >= 0 && j < n;
  }

  void _printMatrix(List<List<String>> matrix) {
    for (var row in matrix) {
      print(row.map((e) => e.isEmpty ? '_' : e).join(' '));
    }
  }
}
