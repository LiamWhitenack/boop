import 'package:flutter/material.dart';

import 'kittens_and_cats.dart';

class Player {
  late List<Kitten> kittens;
  List<Cat> cats = [];
  final String name;
  final Color color;
  Player(this.name, this.color) {
    kittens = List.filled(8, Kitten(this), growable: true);
    // cats = [Cat(this)]; // for testing only
  }

  void reset() {
    kittens = List.filled(8, Kitten(this), growable: true);
    cats = [];
  }

  void upgradePieces(List pieces) {
    int numberOfPiecesPlayerHas = kittens.length + cats.length;
    for (var piece in pieces) {
      kittens.remove(piece);
      cats.remove(piece);
    }
    if (numberOfPiecesPlayerHas - 3 != kittens.length + cats.length) {
      throw Exception('something is wrong with the removal of pieces. \nThe kittens: $kittens \nThe cats: $cats');
    }

    cats.addAll(List.filled(3, Cat(this)));
  }
}
