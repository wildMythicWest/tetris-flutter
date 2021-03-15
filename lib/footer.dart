

import 'package:flutter/material.dart';
import 'package:tetris/game_controller.dart';

class Footer extends StatelessWidget {

  final GameController gameController;

  Footer(this.gameController);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: new Container(
          margin: EdgeInsets.only(top: gameController.gameBoard.tileSize),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new _ControlButton(gameController, "V", () { gameController.gameBoard.activeTetrimino.slam(gameController.gameBoard.staticBlocks);}),
              new SizedBox(width: gameController.gameBoard.tileSize, height: gameController.gameBoard.tileSize,),
              new _ControlButton(gameController, "<", () { gameController.gameBoard.activeTetrimino.moveLeft(gameController.gameBoard.staticBlocks);}),
              new SizedBox(width: gameController.gameBoard.tileSize, height: gameController.gameBoard.tileSize,),
              new _ControlButton(gameController, ">", () { gameController.gameBoard.activeTetrimino.moveRight(gameController.gameBoard.staticBlocks);}),
            ],
          ),
        )
      )
    );
  }

}


class _ControlButton extends StatelessWidget {

  final GameController gameController;
  final String text;
  final VoidCallback callback;

  _ControlButton(this.gameController, this.text, this.callback);

  @override
  Widget build(BuildContext context) {
    return new TextButton(
        onPressed: callback,
        child: new Text(text),
        style: new ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          minimumSize: MaterialStateProperty.all(Size(gameController.gameBoard.tileSize*2, gameController.gameBoard.tileSize*2)),
          textStyle: MaterialStateProperty.all<TextStyle>(
              new TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
    );
  }

}