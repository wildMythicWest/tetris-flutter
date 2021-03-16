import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'grid_point.dart';

class Shape {
  Set<GridPoint> points;
  final String name;
  Color color;

  Shape(this.name, this.points, this.color) {
    points.forEach((point) {
      point.apply(color);
    });
  }

  void applyColor(Color color) {
    this.color = color;
    points.forEach((point) {
      point.apply(color);
    });
  }

  Shape rotateCounterclockwise() {
    Set<GridPoint> updatedPosition = new HashSet();
    points.forEach((element) {
      updatedPosition.add(GridPoint(element.y, -element.x));
    });
    return new Shape(name, updatedPosition, color);
  }

  Shape rotateClockwise() {
    Set<GridPoint> updatedPosition = new HashSet();
    points.forEach((element) {
      updatedPosition.add(GridPoint(-element.y, element.x));
    });
    return new Shape(name, updatedPosition, color);
  }

  @override
  String toString() {
    return 'Shape{$points}';
  }
}

class Shapes {
  static Shape O = Shape("O", Set<GridPoint>.of([
    GridPoint(-1, -1),
    GridPoint(0, -1),
    GridPoint(-1, 0),
    GridPoint(0, 0)]),
      Colors.yellowAccent);

  static Shape I = Shape("I",
      Set<GridPoint>.of([
        GridPoint(0, -2),
        GridPoint(0, -1),
        GridPoint(0, 0),
        GridPoint(0, 1)]),
      Colors.lightBlueAccent);

  static Shape L = Shape("L",
      Set<GridPoint>.of([
        GridPoint(0, -2),
        GridPoint(0, -1),
        GridPoint(0, 0),
        GridPoint(1, 0)]),
      Colors.orangeAccent);

  static Shape J = Shape("J",
      Set<GridPoint>.of([
        GridPoint(-1, -2),
        GridPoint(-1, -1),
        GridPoint(-1, 0),
        GridPoint(-2, 0)]),
      Colors.blueAccent);

  static Shape S = Shape("S",
      Set<GridPoint>.of([
        GridPoint(0, -1),
        GridPoint(1, -1),
        GridPoint(0, 0),
        GridPoint(-1, 0)]),
      Colors.greenAccent);

  static Shape Z = Shape("Z",
      Set<GridPoint>.of([
        GridPoint(-2, -1),
        GridPoint(-1, -1),
        GridPoint(-1, 0),
        GridPoint(0, 0)]),
      Colors.redAccent);

  static Shape T = Shape("T", Set<GridPoint>.of([
        GridPoint(-1, -1),
        GridPoint(0, -1),
        GridPoint(1, -1),
        GridPoint(0, 0)]),
      Colors.pinkAccent);

  static  List<Shape> allShapes = [O, I, L, J, S, Z, T];

}