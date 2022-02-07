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
  double speed = 1;
  double totalStep = 0.0;

  int totalLinesCleared = 0;
  int comboCounter = 1;

  Set<GridPoint> staticBlocks = new HashSet();


  GameBoard(this.gameController);

  onLoad() {
    tileSize = gameController.screenSize.width / tilesW;
    tilesH = (gameController.screenSize.height / tileSize).floor();
  }

  void render(Canvas canvas) {
    drawGameBoardGrid(canvas);

    activeTetrimino.draw(canvas);
    drawStaticBlocks(canvas);
  }

  void update(double t) {
    autoMove(t);
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
    gameController.state.heldShape = null;
    totalLinesCleared = 0;
    speed = 1;
    autoMoveEnabled = false;
    autoMoveDirection = AutoMoveDirection.NONE;
    level = 1;
    linesToNextLevel = 5;
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
    _createTetriminoFromOrigin(GridPoint(5, 0));
  }

  void _createTetriminoFromOrigin(GridPoint origin) {
    if(staticBlocks.where((element) => element.y == 0).isNotEmpty) {
      gameController.state.currentScreen = UIScreen.lost;
    }
    Shape shape = getNextShape();
    Tetrimino newTetrimino = Tetrimino.fromOrigin(origin, shape, tileSize, tilesW, tilesH, staticBlocks);
    if(!newTetrimino.findFreePositionOnBoard(origin, shape)) {
      gameController.state.currentScreen = UIScreen.lost;
    }
    activeTetrimino = newTetrimino;
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
    this.totalLinesCleared += linesCleared;
    linesToNextLevel -= linesCleared;
    changeLevel();
  }

  int level = 1;
  int linesToNextLevel = 5;

  changeLevel() {
    if(linesToNextLevel <= 0) {
      level++;
      linesToNextLevel += level*5;
      changeSpeed();
      gameController.state.update();
    }
  }

  changeSpeed() {
    speed += (level*2)/10;
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
        gameController.state.score += 1200*comboCounter;
        comboCounter++;
        break;
      default:
        comboCounter = 1;
    }
    gameController.state.update();
  }

  void holdTetrimino() {
    GridPoint origin = activeTetrimino.origin;
    if(gameController.state.heldShape != null) {
      Shape currentlyHeld = Shape(
          gameController.state.heldShape.name,
          gameController.state.heldShape.points,
          gameController.state.heldShape.color);
      Tetrimino heldTetrimino = Tetrimino.fromOrigin(origin, currentlyHeld, tileSize, tilesW, tilesH, staticBlocks);
      if(!heldTetrimino.findFreePositionOnBoard(origin, currentlyHeld)) {
        return;
      }
      gameController.state.heldShape = Shape(
          activeTetrimino.shape.name,
          activeTetrimino.shape.points,
          activeTetrimino.shape.color);
      activeTetrimino = heldTetrimino;
    } else {
      gameController.state.heldShape = Shape(
          activeTetrimino.shape.name,
          activeTetrimino.shape.points,
          activeTetrimino.shape.color);
      _createTetriminoFromOrigin(origin);
    }
    gameController.state.update();
  }

  double originalSpeed;

  void beginSoftDrop() {
    originalSpeed = speed;
    speed = originalSpeed * 10;
  }

  void endSoftDrop() {
    speed = originalSpeed;
  }

  bool autoMoveEnabled = false;
  AutoMoveDirection autoMoveDirection = AutoMoveDirection.NONE;
  double autoMoveStep = 0;

  autoMove(double t) async {
    if(!autoMoveEnabled || autoMoveDirection == AutoMoveDirection.NONE) {
      return;
    }
    double step = t * (speed * 10) * tileSize;
    autoMoveStep += step;

    if(autoMoveStep >= tileSize) {
      autoMoveStep = 0;
      if(AutoMoveDirection.LEFT == autoMoveDirection) {
        activeTetrimino.moveLeft();
      } else if(AutoMoveDirection.RIGHT == autoMoveDirection) {
        activeTetrimino.moveRight();
      }
    }
  }

  stopAutoMove() {
    autoMoveEnabled = false;
    autoMoveDirection = AutoMoveDirection.NONE;
  }

  startAutoMoveRight() {
    autoMoveEnabled = true;
    autoMoveDirection = AutoMoveDirection.RIGHT;
  }

  startAutoMoveLeft() {
    autoMoveEnabled = true;
    autoMoveDirection = AutoMoveDirection.LEFT;
  }

  hardDrop() {
    activeTetrimino.hardDrop();
    saveTetrimino(activeTetrimino);
    clearLines(activeTetrimino);
    _createTetrimino();
  }
}

enum AutoMoveDirection {
  LEFT, RIGHT, NONE
}