import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/grid_point.dart';

class Tetrimino {

    final Shape shape;

    List<GridPoint> position;

    final double tileSize;
    final int tilesW;
    final int tilesH;

    double boardBottom;

    Tetrimino(this.shape, this.tileSize, this.tilesW, this.tilesH) {
      boardBottom = tilesH*tileSize;
      position = shape.points;
    }

    void slam(List<GridPoint> staticBlocks) {
      while(canMoveDown(staticBlocks)) {
        moveDown(staticBlocks);
      }
    }

    bool canMoveDown(List<GridPoint> staticBlocks) {
      for(GridPoint point in position) {
        if(point.y >= tilesH -1) {
          return false;
        }
        if(staticBlocks.indexWhere((staticBlock) => staticBlock.y == point.y+1 && staticBlock.x == point.x) != -1) {
          return false;
        }
      }
      return true;
    }

    bool canMoveLeft(List<GridPoint> staticBlocks) {
      for(GridPoint point in position) {
        if(point.x <= 0) {
          return false;
        }
        if(staticBlocks.indexWhere((staticBlock) => staticBlock.x == point.x-1 && staticBlock.y == point.y) != -1) {
          return false;
        }
      }
      return true;
    }

    bool canMoveRight(List<GridPoint> staticBlocks) {
      for(GridPoint point in position) {
        if(point.x >= tilesW - 1) {
          return false;
        }
        if(staticBlocks.indexWhere((staticBlock) => staticBlock.x == point.x+1 && staticBlock.y == point.y) != -1) {
          return false;
        }
      }
      return true;
    }

    bool moveLeft(List<GridPoint> staticBlocks) {
      if(canMoveLeft(staticBlocks)) {
        List<GridPoint> updatedPosition = [];
        position.forEach((element) {
          updatedPosition.add(_moveBlockLeft(element));
        });
        position = updatedPosition;
        return true;
      }
      return false;
    }

    bool moveRight(List<GridPoint> staticBlocks) {
      if(canMoveRight(staticBlocks)) {
        List<GridPoint> updatedPosition = [];
        position.forEach((element) {
          updatedPosition.add(_moveBlockRight(element));
        });
        position = updatedPosition;
        return true;
      }
      return false;
    }

    bool moveDown(List<GridPoint> staticBlocks) {
      if(canMoveDown(staticBlocks)) {
        List<GridPoint> updatedPosition = [];
        position.forEach((element) {
          updatedPosition.add(_moveBlockDown(element));
        });
        position = updatedPosition;
        return true;
      }
      return false;
    }

    GridPoint _moveBlockLeft(GridPoint point) {
      GridPoint newPoint = new GridPoint.withColor(point.x - 1 , point.y, point.color);
      return newPoint;
    }

    GridPoint _moveBlockRight(GridPoint point) {
      GridPoint newPoint = new GridPoint.withColor(point.x + 1 , point.y, point.color);
      return newPoint;
    }

    GridPoint _moveBlockDown(GridPoint point) {
      GridPoint newPoint = new GridPoint.withColor(point.x , point.y + 1, point.color);
      return newPoint;
    }

    void draw(Canvas canvas) {
      position.forEach((element) {
        element.draw(canvas, tileSize);
      });
    }

    bool hasCollided(List<GridPoint> staticBlocks) {
      return !canMoveDown(staticBlocks);
    }
}

class Shape {
  final List<GridPoint> points;
  final String name;
  final Color color;

  Shape(this.name, this.points, this.color) {
    points.forEach((point) {
      point.apply(color);
    });
  }
}

class Shapes {
  static Shape O = Shape("O", [
    GridPoint(4, 0),
    GridPoint(4, 1),
    GridPoint(5, 0),
    GridPoint(5, 1)],
      Colors.yellowAccent);

  static Shape I = Shape("I", [
    GridPoint(4, 0),
    GridPoint(4, 1),
    GridPoint(4, 2),
    GridPoint(4, 3)],
      Colors.lightBlueAccent);

  static Shape L = Shape("L", [
    GridPoint(4, 0),
    GridPoint(4, 1),
    GridPoint(4, 2),
    GridPoint(5, 2)],
      Colors.orangeAccent);

  static Shape J = Shape("J", [
    GridPoint(4, 0),
    GridPoint(4, 1),
    GridPoint(4, 2),
    GridPoint(3, 2)],
      Colors.blueAccent);

  static Shape S = Shape("S", [
    GridPoint(4, 0),
    GridPoint(5, 0),
    GridPoint(4, 1),
    GridPoint(3, 1)],
      Colors.greenAccent);

  static Shape Z = Shape("Z", [
    GridPoint(4, 0),
    GridPoint(5, 0),
    GridPoint(5, 1),
    GridPoint(6, 1)],
      Colors.redAccent);

  static Shape T = Shape("T", [
    GridPoint(3, 0),
    GridPoint(4, 0),
    GridPoint(5, 0),
    GridPoint(4, 1)],
      Colors.pinkAccent);

  static  List<Shape> allShapes = [O, I, L, J, S, Z, T];

}