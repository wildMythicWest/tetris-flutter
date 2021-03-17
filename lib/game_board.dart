import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';
import 'package:tetris/tetrimino.dart';
import 'package:tetris/tetris_game.dart';
import 'package:tetris/tetris_game_ui.dart';

import 'grid_point.dart';

class GameBoard {

  Tetrimino activeTetrimino;
  final TetrisGame gameController;
  double tileSize;
  final int tilesW = 10;
  int tilesH;
  int speed = 1;
  double totalStep = 0.0;

  int comboCounter = 1;

  Set<GridPoint> staticBlocks = new HashSet();


  GameBoard(this.gameController) {
    tileSize = gameController.screenSize.width / tilesW;
    tilesH = (gameController.screenSize.height / tileSize).floor();
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
      if(!activeTetrimino.moveDown()) {
        saveTetrimino(activeTetrimino);
        clearLines(activeTetrimino);
        _createTetrimino();
      }
    }
  }

  void startNewGame() {
    staticBlocks = new HashSet();
    comboCounter = 1;
    gameController.state.score = 0;
    initNextShapes();
    _createTetrimino();
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

  Queue<Shape> nextShapes = new Queue();

  void initNextShapes() {
    nextShapes = new Queue();
    for(int i = 0; i < 3; i++) {
      Shapes.allShapes.shuffle(Random());
      nextShapes.add(Shapes.allShapes.first);
    }
  }

  Shape getNextShape() {
    Shapes.allShapes.shuffle(Random());
    nextShapes.add(Shapes.allShapes.first);
    Shape next = nextShapes.removeFirst();
    redrawNextShapes();
    return next;
  }

  void redrawNextShapes() {
    List<Shape> shapes = nextShapes.toList();
    gameController.state.nextShape1 = shapes.elementAt(0);
    gameController.state.nextShape2 = shapes.elementAt(1);
    gameController.state.nextShape3 = shapes.elementAt(2);
    gameController.state.update();
  }

  void _createTetrimino() {
    if(staticBlocks.where((element) => element.y == 0).isNotEmpty) {
      gameController.state.currentScreen = UIScreen.lost;
    }
    Shape shape = getNextShape();
    activeTetrimino = Tetrimino(shape, tileSize, tilesW, tilesH, staticBlocks);
  }

  void drawStaticBlocks(Canvas canvas) {
    staticBlocks.forEach((block) {
      block.draw(canvas, tileSize);
    });
  }

  void saveTetrimino(Tetrimino tetrimino) {
    tetrimino.positionOnBoard().forEach((element) {
      staticBlocks.add(element);
    });
  }

  void clearLines(Tetrimino collidedTetrimino) {
    Set<int> rows = new HashSet();
    collidedTetrimino.positionOnBoard().forEach((element) {
      rows.add(element.y);
    });

    Set<GridPoint> newStaticBlocks = staticBlocks;

    List<int> sortedRows = rows.toList();
    sortedRows.sort();
    int linesCleared = 0;
    for (var row in sortedRows) {
      Set<GridPoint> line = Set.from(staticBlocks.where((element) => row == element.y));
      if(line.length == 10) {
        newStaticBlocks = newStaticBlocks.difference(line);
        newStaticBlocks.forEach((element) {
          if(element.y < row) {
            element.y += 1;
          }
        });
        linesCleared++;
      }
    }
    staticBlocks = newStaticBlocks;

    changeScore(linesCleared);
  }

  void changeScore(int linesCleared) {
    switch(linesCleared) {
      case 1:
        gameController.state.score += 100*comboCounter;
        comboCounter++;
        break;
      case 2:
        gameController.state.score += 200*comboCounter;
        comboCounter++;
        break;
      case 3:
        gameController.state.score += 400*comboCounter;
        comboCounter++;
        break;
      case 4:
        gameController.state.score += 800*comboCounter;
        comboCounter++;
        break;
      default:
        comboCounter = 1;
    }
    gameController.state.update();
  }
}