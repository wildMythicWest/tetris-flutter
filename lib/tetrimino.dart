import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/grid_point.dart';
import 'package:tetris/shape.dart';

class Tetrimino {

    final Shape shape;

    GridPoint origin;

    final double tileSize;
    final int tilesW;
    final int tilesH;

    double boardBottom;

    Tetrimino(this.shape, this.tileSize, this.tilesW, this.tilesH) {
      boardBottom = tilesH*tileSize;
      origin = GridPoint(4, 0);
    }

    Set<GridPoint> positionOnBoard(GridPoint fromOrigin) {
      Set<GridPoint> currentPosition = new HashSet();
      shape.points.forEach((element) {
        currentPosition.add(GridPoint.withColor(element.x + fromOrigin.x, element.y + fromOrigin.y, element.color));
      });
      return currentPosition;
    }

    void hardDrop(Set<GridPoint> staticBlocks) {
      while(true) {
        if(!moveDown(staticBlocks)) {
          break;
        }
      }
    }

    void softDrop() {

    }

    //Move block first, after moved, check if it will collide, if does not collide we make it the new position

    bool hasCollidedWithBoard(Set<GridPoint> newPosition) {
      for (var point in newPosition) {
        if(point.y > tilesH -1) {
          return true;
        }

        if(point.x < 0) {
          return true;
        }

        if(point.x > tilesW - 1) {
          return true;
        }
      }
      return false;
    }

    bool canMove(GridPoint newOrigin, Set<GridPoint> staticBlocks) {
      Set<GridPoint> newPosition = positionOnBoard(newOrigin);
      Set intersection = staticBlocks.intersection(newPosition);
      return intersection.isEmpty && !hasCollidedWithBoard(newPosition);
    }

    bool moveLeft(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockLeft();
      if(canMove(newOrigin, staticBlocks)) {
        origin = newOrigin;
        return true;
      }
      return false;
    }

    bool moveRight(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockRight();
      if(canMove(newOrigin, staticBlocks)) {
        origin = newOrigin;
        return true;
      }
      return false;
    }

    bool moveDown(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockDown();
      if(canMove(newOrigin, staticBlocks)) {
        origin = newOrigin;
        return true;
      }
      return false;
    }

    GridPoint _moveBlockLeft() {
      return new GridPoint(origin.x - 1 , origin.y);
    }

    GridPoint _moveBlockRight() {
      return new GridPoint(origin.x + 1 , origin.y);
    }

    GridPoint _moveBlockDown() {
      return new GridPoint(origin.x , origin.y + 1);
    }

    void draw(Canvas canvas) {
      positionOnBoard(origin).forEach((element) {
        element.draw(canvas, tileSize);
      });
    }
}