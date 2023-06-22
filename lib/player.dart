import 'package:flutter/material.dart';

import 'kittens_and_cats.dart';

class Player {
  late List<Kitten> kittens;
  late List<Kitten> tempKittens;
  List<Cat> cats = [];
  List<Cat> tempCats = [];
  String name;
  final Color color;
  Player(this.name, this.color) {
    kittens = List.filled(8, Kitten(this), growable: true);
    tempKittens = List.filled(8, Kitten(this), growable: true);
    // cats = [Cat(this)]; // for testing only
    // tempCats = [Cat(this)];
  }

  void reset() {
    kittens = List.filled(8, Kitten(this), growable: true);
    tempKittens = List.filled(8, Kitten(this), growable: true);
    cats = [];
    tempCats = [];
  }

  void revertKittensAndCats() {
    tempKittens = List<Kitten>.from(kittens);
    tempCats = List<Cat>.from(cats);
  }

  void updateKittensAndCats() {
    kittens = List<Kitten>.from(tempKittens);
    cats = List<Cat>.from(tempCats);
  }

  void upgradePieces(List pieces) {
    int numberOfPiecesPlayerHas = kittens.length + cats.length;
    for (var piece in pieces) {
      tempKittens.remove(piece);
      tempCats.remove(piece);
    }
    if (numberOfPiecesPlayerHas - 3 != tempKittens.length + tempCats.length) {
      throw Exception(
          'something is wrong with the removal of pieces. \nThe kittens: $tempKittens \nThe tempCats: $tempCats');
    }

    tempCats.addAll(List.filled(3, Cat(this)));
  }
}
