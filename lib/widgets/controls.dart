import 'package:flutter/material.dart';


class MoveLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_left,
      color: Colors.green,
      size: 60.0,
    );
  }
}

class MoveRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right,
      color: Colors.green,
      size: 60.0,
    );
  }
}

class RotateLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.rotate_left,
      color: Colors.green,
      size: 60.0,
    );
  }
}

class RotateRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.rotate_right,
      color: Colors.green,
      size: 60.0,
    );
  }
}

class Hold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.swap_vert,
      color: Colors.green,
      size: 60.0,
    );
  }

}

class Drop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_downward,
      color: Colors.green,
      size: 60.0,
    );
  }
}

class SoftDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.expand_more,
      color: Colors.green,
      size: 60.0,
    );
  }
}
