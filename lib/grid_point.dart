import 'dart:ui';

class GridPoint {
  int x;
  int y;
  Color color;

  GridPoint(this.x, this.y);

  GridPoint.withColor(this.x, this.y, this.color);

  void apply(Color color) {
    this.color = color;
  }

  void draw(Canvas canvas, double tileSize) {
    Rect rect = Rect.fromLTWH(tileSize*x, tileSize*y, tileSize, tileSize);
    canvas.drawRect(rect, Paint()..color = color);
  }

}