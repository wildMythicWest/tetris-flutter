import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/tetris_game.dart';
import 'package:tetris/tetris_game_ui.dart';

import 'bgm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);


  await BGM.add("Tetris_theme.ogg");
  await BGM.add("banjo_tetris_loop.mp3");

  TetrisGameUi gameUI = TetrisGameUi();
  TetrisGame game = TetrisGame(gameUI.state);
  gameUI.state.game = game;

  double gameBottom = game.hasLayout ? game.size.y - game.screenSize.width : 0;
  double gameRight = game.hasLayout ? game.size.x - game.screenSize.width : 0;

  runApp(MaterialApp(
    title: 'Tetris Game',
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: GameWidget(game: game,),
            bottom: gameBottom,
            right: gameRight,
          ),
          Positioned.fill(
            child: gameUI,
          ),
        ],
      ),
    ),
    debugShowCheckedModeBanner: false,
  ),
  );
  BGM.play(1, 0.3);
}