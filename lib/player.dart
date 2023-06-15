import 'kittens_and_cats.dart';

class Player {
  late List<Kitten> kittens;
  List<Cat> cats = [];
  final String name;
  Player(this.name) {
    kittens = List.filled(8, Kitten(name), growable: true);
  }
}
