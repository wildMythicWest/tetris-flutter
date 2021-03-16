import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/game_controller.dart';
import 'package:tetris/shape.dart';
import 'package:tetris/tetrimino.dart';

import 'grid_point.dart';

class GameBoard {

  Tetrimino activeTetrimino;
  final GameController gameController;
  double tileSize;
  final int tilesW = 10;
  int tilesH;
  int speed = 1;
  double totalStep = 0.0;

  Set<GridPoint> staticBlocks = new HashSet();


  GameBoard(this.gameController) {
    tileSize = gameController.screenSize.width / tilesW;
    tilesH = (gameController.screenSize.height / tileSize).floor();
    _createTetrimino();
  }

  void render(Canvas canvas) {
    drawGameBoardGrid(canvas);

    activeTetrimino.draw(canvas);
    drawStaticBlocks(canvas);
  }

  void update(double t) {
    double step = t * speed * tileSize;
    totalStep += step;

    if(totalStep >= tileSize) {
      totalStep = 0;
      if(!activeTetrimino.moveDown(staticBlocks)) {
        saveTetrimino(activeTetrimino);
        clearTetris(activeTetrimino);
        _createTetrimino();
      }
    }
  }

  void drawGameBoardGrid(Canvas canvas) {
    for(int h = 0; h < tilesH; h++) {
      for(int w = 0; w < tilesW; w++) {
        drawGridBlock(canvas, w, h);
      }
    }
  }

  drawGridBlock(Canvas canvas, int left, int top) {
    Rect background = Rect.fromLTWH(left*tileSize, top*tileSize, tileSize, tileSize);
    Paint backgroundPaint = Paint()..color = Colors.greenAccent;
    backgroundPaint..style = PaintingStyle.stroke;
    canvas.drawRect(background, backgroundPaint);
  }

  void _createTetrimino() {
    if(staticBlocks.where((element) => element.y == 0).isNotEmpty) {
      staticBlocks = new HashSet();
    }
    Shapes.allShapes.shuffle(Random());
    activeTetrimino = Tetrimino(Shapes.allShapes.first, tileSize, tilesW, tilesH);
  }

  void drawStaticBlocks(Canvas canvas) {
    staticBlocks.forEach((block) {
      block.draw(canvas, tileSize);
    });
  }

  void saveTetrimino(Tetrimino tetrimino) {
    tetrimino.positionOnBoard(activeTetrimino.origin).forEach((element) {
      staticBlocks.add(element);
    });
  }

  void clearTetris(Tetrimino collidedTetrimino) {
    Set<int> rows = new HashSet();
    collidedTetrimino.positionOnBoard(activeTetrimino.origin).forEach((element) {
      rows.add(element.y);
    });

    Set<GridPoint> newStaticBlocks = staticBlocks;

    List<int> sortedRows = rows.toList();
    sortedRows.sort();

    for (var row in sortedRows) {
      Set<GridPoint> line = Set.from(staticBlocks.where((element) => row == element.y));
      if(line.length == 10) {
        newStaticBlocks = newStaticBlocks.difference(line);
        newStaticBlocks.forEach((element) {
          if(element.y < row) {
            element.y += 1;
          }
        });
      }
    }
    staticBlocks = newStaticBlocks;
  }
}