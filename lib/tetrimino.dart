import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/grid_point.dart';

class Tetrimino {

    final Shape shape;

    List<Rect> position = [];

    final double tileSize;
    final int tilesW;
    final int tilesH;

    double boardBottom;

    Tetrimino(this.shape, this.tileSize, this.tilesW, this.tilesH) {
      boardBottom = tilesH*tileSize;
      shape.points.forEach((element) {
        position.add(_createRect(element.x, element.y));
      });
    }

    void slam() {
      List<Rect> updatedPosition = [];
      position.forEach((element) {
        updatedPosition.add(_moveBlockDown(element, _calculateDistanceToBottom()));
      });
      position = updatedPosition;
    }

    double _calculateDistanceToBottom() {
      return (tilesH * tileSize) - lowestPoint();
    }

    void moveLeft() {
      List<Rect> updatedPosition = [];
      position.forEach((element) {
        updatedPosition.add(_moveBlockLeft(element, tileSize));
      });
      position = updatedPosition;
    }

    void moveRight() {
      List<Rect> updatedPosition = [];
      position.forEach((element) {
        updatedPosition.add(_moveBlockRight(element, tileSize));
      });
      position = updatedPosition;
    }

    Rect _moveBlockLeft(Rect rect, double step) {
      return Rect.fromLTWH(rect.left - step, rect.top, rect.width, rect.height);
    }

    Rect _moveBlockRight(Rect rect, double step) {
      return Rect.fromLTWH(rect.left + step, rect.top, rect.width, rect.height);
    }

    void draw(Canvas canvas) {
      position.forEach((element) {
        canvas.drawRect(element, Paint()..color = shape.color);
      });
    }

    Rect _createRect(int x, int y) {
      return Rect.fromLTWH(tileSize*(x+4), tileSize*y, tileSize, tileSize);
    }

    void moveTetriminoDown(double step) {
      List<Rect> updatedPosition = [];
      position.forEach((element) {
        updatedPosition.add(_moveBlockDown(element, step));
      });
      position = updatedPosition;
    }

    Rect _moveBlockDown(Rect rect, double step) {
      return Rect.fromLTWH(rect.left, rect.top + step, rect.width, rect.height);
    }

    double lowestPoint() {
      double lowestPoint = 0.0;
      position.forEach((element) {
        if(element.bottom > lowestPoint) {
          lowestPoint = element.bottom;
        }
      });
      return lowestPoint;
    }

    bool hasTouchedBottom() {
      for(Rect element in position) {
        if(element.bottom >= boardBottom) {
          return true;
        }
      }
      return false;
    }

}

class Shape {
  final List<GridPoint> points;
  final String name;
  final Color color;
  Shape(this.name, this.points, this.color);
}

class Shapes {
  static Shape O = Shape("O", [GridPoint(1, 1), GridPoint(1, 2),
    GridPoint(2,1), GridPoint(2, 2)], Colors.yellowAccent);

  static Shape I = Shape("I", [GridPoint(1, 1), GridPoint(1, 2),
    GridPoint(1,3), GridPoint(1, 4)], Colors.lightBlueAccent);

  static Shape L = Shape("L", [GridPoint(1, 1), GridPoint(2, 1),
    GridPoint(3,1), GridPoint(3, 2)], Colors.orangeAccent);

  static Shape J = Shape("J", [GridPoint(2, 1), GridPoint(2, 2),
    GridPoint(2,3), GridPoint(1, 3)], Colors.blueAccent);

  static Shape S = Shape("S", [GridPoint(1, 2), GridPoint(2, 2),
    GridPoint(2,1), GridPoint(3, 1)], Colors.greenAccent);

  static Shape Z = Shape("Z", [GridPoint(1, 1), GridPoint(2, 1),
    GridPoint(2,2), GridPoint(3, 2)], Colors.redAccent);

  static Shape T = Shape("T", [GridPoint(1, 1), GridPoint(2, 1),
    GridPoint(3,1), GridPoint(2, 2)], Colors.pinkAccent);

  static  List<Shape> allShapes = [O, I, L, J, S, Z, T];

}