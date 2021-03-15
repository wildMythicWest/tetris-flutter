import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/game_controller.dart';
import 'package:tetris/tetrimino.dart';

class GameBoard {

  Tetrimino activeTetrimino;
  final GameController gameController;
  double tileSize;
  final int tilesW = 10;
  int tilesH;
  int speed = 1;
  double totalStep = 0.0;

  List<Tetrimino> staticBlocks = [];


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

    if(activeTetrimino.hasTouchedBottom()) {
      saveTetrimino(activeTetrimino);
      _createTetrimino();
    } else {
      if(totalStep >= tileSize) {
        totalStep -= tileSize;
        activeTetrimino.moveTetriminoDown(tileSize*speed);
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
    Shapes.allShapes.shuffle(Random());
    activeTetrimino = Tetrimino(Shapes.allShapes.first, tileSize, tilesW, tilesH);
  }

  void drawStaticBlocks(Canvas canvas) {
    staticBlocks.forEach((tetrimino) {
      tetrimino.draw(canvas);
    });
  }

  void saveTetrimino(Tetrimino tetrimino) {
    staticBlocks.add(tetrimino);
  }

  bool hasTouchedStaticBlock(Tetrimino tetrimino) {
//    for(Tetrimino element in staticBlocks) {
//      if(element.top < tetrimino.lowestPoint()) {
//        return true;
//      }
//    }
    return false;
  }
}