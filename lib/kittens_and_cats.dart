// import 'package:flutter/material.dart';
import 'package:boop/player.dart';
import 'package:flutter/material.dart';

class Kitten {
  final Player player;
  late Widget widget;
  Kitten(this.player) {
    widget = KittenWidget(kittenColor: player.color);
  }
}

class Cat {
  final Player player;
  late Widget widget;
  Cat(this.player) {
    widget = CatWidget(catColor: player.color);
  }
}

class CatWidget extends StatelessWidget {
  final Color catColor;

  const CatWidget({
    super.key,
    required this.catColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return Center(
      child: Container(
        color: catColor,
        height: limitingSize * 0.075,
        width: limitingSize * 0.075,
      ),
    );
  }
}

class KittenWidget extends StatelessWidget {
  final Color kittenColor;
  const KittenWidget({
    super.key,
    required this.kittenColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double limitingSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return Center(
      child: Icon(Icons.circle, color: kittenColor, size: limitingSize * 0.075),
    );
  }
}
