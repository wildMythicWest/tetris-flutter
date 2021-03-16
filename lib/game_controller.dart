import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/game_board.dart';

class GameController extends Game {
  Size screenSize;
  GameBoard gameBoard;

  GameController(this.screenSize) {
    initialize();
  }

  void initialize() async {
    gameBoard = GameBoard(this);
  }

  void render(Canvas canvas) {
//    canvas.drawRect(Rect.fromPoints(Offset(0.0, 0.0), Offset(10.0, 10.0)), Paint()..color = Colors.black);

    gameBoard.render(canvas);
  }

  void update(double t) {
    gameBoard.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }
}