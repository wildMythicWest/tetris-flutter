


import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'footer.dart';
import 'game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  Size screenSize = await flameUtil.initialDimensions();

  Size gameBoardSize = determineBoardArea(screenSize);
  Size footerSize = determineFooterArea(screenSize);

  GameController gameController = new GameController(gameBoardSize);
  Footer footer = new Footer(gameController);
  runApp(MaterialApp(
    title: 'Tetris Game',
    theme: ThemeData.dark(),
    home: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fromRect(
            rect: Rect.fromLTWH(0, 0, gameBoardSize.width, gameBoardSize.height),
            child: gameController.widget,
          ),
          Positioned.fromRect(
              rect: Rect.fromLTWH(0, gameBoardSize.height, footerSize.width, footerSize.height),
              child: footer,
          ),
        ],
      ),
    ),
    debugShowCheckedModeBanner: false,
  ),
  );
}

Size determineBoardArea(Size screenSize) {
  return new Size(screenSize.width, screenSize.height * 4 / 5);
}

Size determineFooterArea(Size screenSize) {
  return new Size(screenSize.width, screenSize.height / 5);
}