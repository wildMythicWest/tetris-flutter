import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/grid_point.dart';
import 'package:tetris/shape.dart';

class Tetrimino {

    Shape shape;
    GridPoint origin;

    final Set<GridPoint> staticBlocks;
    final double tileSize;
    final int tilesW;
    final int tilesH;

    Tetrimino(this.shape, this.tileSize, this.tilesW, this.tilesH, this.staticBlocks) {
      origin = GridPoint(5, 0);
    }

    Tetrimino.fromOrigin(GridPoint origin, this.shape, this.tileSize, this.tilesW, this.tilesH, this.staticBlocks) {
      this.origin = origin;
    }

    Set<GridPoint> position(GridPoint origin, Shape shape) {
      Set<GridPoint> currentPosition = new HashSet();
      shape.points.forEach((element) {
        currentPosition.add(GridPoint.withColor(element.x + origin.x, element.y + origin.y, element.color));
      });
      return currentPosition;
    }

    Set<GridPoint> positionOnBoard() {
      return position(origin, shape);
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

    bool canMove(GridPoint origin, Set<GridPoint> staticBlocks, Shape shape) {
      Set<GridPoint> blockPosition = position(origin, shape);
      Set intersection = staticBlocks.intersection(blockPosition);
      return intersection.isEmpty && !hasCollidedWithBoard(blockPosition);
    }

    bool moveLeft(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockLeft();
      if(canMove(newOrigin, staticBlocks, shape)) {
        origin = newOrigin;
        return true;
      }
      return false;
    }

    bool moveRight(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockRight();
      if(canMove(newOrigin, staticBlocks, shape)) {
        origin = newOrigin;
        return true;
      }
      return false;
    }

    bool moveDown(Set<GridPoint> staticBlocks) {
      GridPoint newOrigin = _moveBlockDown();
      if(canMove(newOrigin, staticBlocks, shape)) {
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
      positionOnBoard().forEach((element) {
        element.draw(canvas, tileSize);
      });
      drawGhost(canvas);
    }

    void drawGhost(canvas) {
      projection().forEach((element) {
        element.drawWithColor(canvas, tileSize, Colors.white30);
      });
    }

    Set<GridPoint> projection() {
      Tetrimino ghost = Tetrimino.fromOrigin(origin, shape, tileSize, tilesW, tilesH, staticBlocks);
      ghost.hardDrop(staticBlocks);
      return ghost.positionOnBoard();
    }

    bool canRotate(Set<GridPoint> staticBlocks, Shape shape) {
      return canMove(origin, staticBlocks, shape);
    }

  void rotateCounterclockwise(Set<GridPoint> staticBlocks) {
    Shape newShape = shape.rotateCounterclockwise();
    if(canRotate(staticBlocks, newShape)) {
      shape = newShape;
    }
  }

  void rotateClockwise(Set<GridPoint> staticBlocks) {
    Shape newShape = shape.rotateClockwise();
    if(canRotate(staticBlocks, newShape)) {
      shape = newShape;
    }
  }
}