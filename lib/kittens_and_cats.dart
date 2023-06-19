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
    final double gridLength = limitingSize == screenWidth ? screenWidth * 0.95 : limitingSize * 0.65;
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            color: Colors.white38,
            height: gridLength * 0.125,
            width: gridLength * 0.125,
          ),
          Container(
            color: catColor,
            height: gridLength * 0.1,
            width: gridLength * 0.1,
          ),
        ],
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
    final double gridLength = limitingSize == screenWidth ? screenWidth * 0.95 : limitingSize * 0.65;
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(Icons.circle, color: Colors.white38, size: gridLength * 0.125),
          Icon(
            Icons.circle,
            color: kittenColor,
            size: gridLength * 0.1,
          ),
        ],
      ),
    );
  }
}
