import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';
import 'package:tetris/status_area.dart';
import 'package:tetris/tetrimino.dart';
import 'package:tetris/tetris_game.dart';
import 'package:tetris/widgets/controls.dart';

import 'bgm.dart';

class TetrisGameUi extends StatefulWidget {

  final TetrisGameUiState state = TetrisGameUiState();

  @override
  State<StatefulWidget> createState() => state;

}

class TetrisGameUiState extends State<TetrisGameUi> with WidgetsBindingObserver {
  TetrisGame game;
  bool isBGMEnabled = true;
  bool isSFXEnabled = true;

  UIScreen currentScreen = UIScreen.home;

  int score = 0;
  int highScore = 0;

  Shape nextShape1;
  Shape nextShape2;
  Shape nextShape3;

  Shape heldShape;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  Widget spacer({int size}) {
    return Expanded(
      flex: size ?? 100,
      child: Center(),
    );
  }

  Widget bgmControlButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: isBGMEnabled ? Colors.white : Colors.grey,
        icon: Icon(
          isBGMEnabled ? Icons.volume_up : Icons.volume_off,
        ),
        onPressed: () {
          isBGMEnabled = !isBGMEnabled;
          if (isBGMEnabled) {
            BGM.resume();
          } else {
            BGM.pause();
          }
          update();
        },
      ),
    );
  }

  Widget sfxControlButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: TextButton(
        child: Text(
          "sfx",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: isSFXEnabled ? Colors.white : Colors.grey,
              decoration: isSFXEnabled ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
        onPressed: () {
          isSFXEnabled = !isSFXEnabled;
          update();
        },
      ),
    );
  }

  Widget topControls() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 15),
      child: Row(
        children: <Widget>[
          bgmControlButton(),
          sfxControlButton(),
          spacer(),
          scoreDisplay(),
        ],
      ),
    );
  }

  Widget scoreDisplay() {
    return Row(
      children: <Widget>[
        Text(
          "Level: " + game.gameBoard.level.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20,),
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Icon(
            Icons.stars,
            color: Colors.white,
          ),
        ),
        Text(
          score.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );;
  }

  Widget buildScreenHome() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Center(
              child: RaisedButton(
                color: Color(0xff032626),
                child: Text(
                  'Start!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 20,
                ),
                onPressed: () {
                  currentScreen = UIScreen.playing;
                  game.start();
                  update();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScreenPlaying() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(size: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        "Next:",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 70, height: 50,),
                      CustomPaint(
                        painter: NextShapePainter(nextShape1),
                      ),
                      SizedBox(width: 70, height: 100,),
                      CustomPaint(
                        painter: NextShapePainter(nextShape2),
                      ),
                      SizedBox(width: 70, height: 100,),
                      CustomPaint(
                        painter: NextShapePainter(nextShape3),
                      ),
                      SizedBox(width: 70, height: 70,),
                      Text(
                        "Hold:",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 70, height: 40,),
                      CustomPaint(
                        painter: NextShapePainter(heldShape),
                      ),
                    ],
                  ),
                ],
              ),
          spacer(size: 45),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              children: <Widget>[
                spacer(),
                GestureDetector(
                  onTapDown: (_) => game.gameBoard.activeTetrimino.moveDown(),
                  onVerticalDragStart: (_) => game.gameBoard.hardDrop(),
                  onLongPressStart: (_) => game.gameBoard.beginSoftDrop(),
                  onLongPressEnd: (_) => game.gameBoard.endSoftDrop(),
                  behavior: HitTestBehavior.opaque,
                  child: Drop(),
                ),
                spacer(),
                GestureDetector(
                  onTapDown: (TapDownDetails d) => game.gameBoard.activeTetrimino.moveLeft(),
                  onLongPressStart: (_) => game.gameBoard.startAutoMoveLeft(),
                  onLongPressEnd: (_) => game.gameBoard.stopAutoMove(),
                  behavior: HitTestBehavior.opaque,
                  child: MoveLeft(),
                ),
                spacer(),
                GestureDetector(
                  onTapDown: (TapDownDetails d) => game.gameBoard.activeTetrimino.moveRight(),
                  onLongPressStart: (_) => game.gameBoard.startAutoMoveRight(),
                  onLongPressEnd: (_) => game.gameBoard.stopAutoMove(),
                  behavior: HitTestBehavior.opaque,
                  child: MoveRight(),
                ),
                spacer(),
                GestureDetector(
                  onTapDown: (TapDownDetails d) => game.gameBoard.activeTetrimino.rotateClockwise(),
                  behavior: HitTestBehavior.opaque,
                  child: RotateRight(),
                ),
                spacer(),
                GestureDetector(
                  onTapDown: (TapDownDetails d) => game.gameBoard.holdTetrimino(),
                  behavior: HitTestBehavior.opaque,
                  child: Hold(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEndGameScreen() {
    List<Widget> children = [];
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          'Game Over!',
          style: TextStyle(
            fontSize: 30,
            color: Colors.red,
          ),
        ),
      ),
    );
    children.add(Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Final Score: ' + score.toString(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
    );
    children.add(Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Total lines cleared: ' + game.gameBoard.totalLinesCleared.toString(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
    );
    children.add(Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Level: ' + game.gameBoard.level.toString(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
    );
    if (score >= highScore && score > 0) {
      children.add(
        Text(
          'New High-Score!',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            shadows: <Shadow>[
              Shadow(
                blurRadius: 3,
                color: Color(0xff000000),
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      );
    }
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 15, bottom: 20),
        child: RaisedButton(
          color: Color(0xff032626),
          child: Text(
            'Play Again!',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            currentScreen = UIScreen.playing;
            game.start();
            update();
          },
        ),
      ),
    );

    return Positioned.fill(
      child: Column(
        children: <Widget>[
          SimpleDialog(
            backgroundColor: Color(0xddffffff),
            children: <Widget>[
              Column(
                children: children,
              ),
            ],
          ),
          spacer(),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        topControls(),
        Expanded(
          child: IndexedStack(
            sizing: StackFit.expand,
            children: <Widget>[
              buildScreenHome(),
              buildScreenPlaying(),
              buildEndGameScreen(),
            ],
            index: currentScreen.index,
          ),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isBGMEnabled) {
      BGM.resume();
    } else {
      BGM.pause();
    }
  }
}

enum UIScreen {
  home,
  playing,
  lost,
}
