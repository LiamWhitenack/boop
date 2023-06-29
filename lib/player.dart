import 'package:flutter/material.dart';

import 'kittens_and_cats.dart';

class Player {
  late List<Kitten> kittens = [];
  late List<Kitten> tempKittens = [];
  List<Cat> cats = [];
  List<Cat> tempCats = [];
  String name;
  final Color color;
  // turn this on for an AI player
  bool automaticallyTakeTurns = false;
  Player(this.name, this.color) {
    kittens = List.filled(8, Kitten(this), growable: true);
    tempKittens = List.filled(8, Kitten(this), growable: true);
    // cats = List.filled(8, Cat(this), growable: true);
    // tempCats = List.filled(8, Cat(this), growable: true);
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

  Player clone() {
    Player clone = Player(name, color);
    clone.kittens = List.filled(tempKittens.length, Kitten(clone), growable: true);
    clone.tempKittens = List.filled(tempKittens.length, Kitten(clone), growable: true);
    clone.cats = List.filled(tempCats.length, Cat(clone), growable: true);
    clone.tempCats = List.filled(tempCats.length, Cat(clone), growable: true);
    clone.automaticallyTakeTurns = automaticallyTakeTurns;
    return clone;
  }
}
