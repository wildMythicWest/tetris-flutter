import 'package:flutter/material.dart';

class WhilePressedButton extends StatelessWidget {

  final VoidCallback callback;
  final String text;
//  bool _buttonPressed = false;

  WhilePressedButton(this.text, this.callback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Listener(
          onPointerDown: (details) {
//            _buttonPressed = true;
            callback.call();
          },
          onPointerUp: (details) {
//            _buttonPressed = false;
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.orange, border: Border.all(color: Colors.green)),
            padding: EdgeInsets.all(16.0),
            child: Text(text),
          ),
        ),
      ),
    );
  }

}