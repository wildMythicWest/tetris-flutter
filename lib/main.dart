import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/tetris_game.dart';
import 'package:tetris/tetris_game_ui.dart';

import 'bgm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  Size screenSize = await flameUtil.initialDimensions(); //20x20

  double gameScreenWidth = screenSize.width * 4 / 5;
  double gameScreenHeight = screenSize.height * 4 / 5;
  Size gameScreenSize = Size(gameScreenWidth, gameScreenHeight);

  double gameBottom = screenSize.height - gameScreenWidth;
  double gameRight = screenSize.width - gameScreenWidth;

  await BGM.add("Tetris_theme.ogg");

  TetrisGameUi gameUI = TetrisGameUi();
  TetrisGame game = TetrisGame(gameUI.state, gameScreenSize);
  gameUI.state.game = game;

  runApp(MaterialApp(
    title: 'Tetris Game',
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: game.widget,
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
  BGM.play(0, 0.3);
}