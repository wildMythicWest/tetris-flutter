import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tetris/tetris_game_ui.dart';

import 'game_board.dart';

class TetrisGame extends FlameGame {

  Size screenSize;
  GameBoard gameBoard;
  final TetrisGameUiState state;

  TetrisGame(this.state) {
    gameBoard = GameBoard(this);
  }

  @override
  Future<void> onLoad() async {
    screenSize = Size(size.x * 4 / 5, size.y * 4 / 5);
    gameBoard.onLoad();
  }

  void start() {
    gameBoard.startNewGame();
  }

  void render(Canvas canvas) {
    if(state.currentScreen != UIScreen.playing) return;
    gameBoard.render(canvas);
  }

  void update(double t) {
    if(state.currentScreen != UIScreen.playing) return;
    gameBoard.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }
}