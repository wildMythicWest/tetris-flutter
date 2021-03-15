import 'dart:ui';

class GridPoint {
  int x;
  int y;

  GridPoint(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void drawRect(Canvas canvas, Color color, double tileSize) {
    Rect rect = Rect.fromLTWH(tileSize*x, tileSize*y, tileSize, tileSize);
    canvas.drawRect(rect, Paint()..color = color);
  }

}