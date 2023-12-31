// ignore_for_file: avoid_print

import 'dart:io';

import 'package:boop/player.dart';
import 'package:flutter/material.dart';
import 'board.dart';
// import 'package:flutter/material.dart';

String? takeTurn(Board board, Player player1, String pieceType, int row, int column) {
  if (pieceType == 'Cat') {
    board.boopCat(row, column, player1);
  } else {
    board.boopKitten(row, column, player1);
  }

  board.updateGrid();

  board.checkForWin();
  if (board.winner != null) {
    return player1.name;
  }

  board.upgradeThreeInARows();
  List<Player> players = board.getPlayers();
  for (Player player in players) {
    if (player.tempCats.length + player.tempKittens.length > 8) {
      throw Exception();
    }
    player.updateKittensAndCats();
  }

  return null;
}

void playGame() {
  Player ralph = Player('Tim', Colors.orange);
  Player jack = Player('The Bad Guy', Colors.orange);

  Board board = Board(ralph, jack);

  bool playerOneTurn = true;

  String? winner;

  String? pieceType;
  int? row;
  int? column;

  while (true) {
    // input piece type
    while (true) {
      print('Would you like to place a Cat or a Kitten?');
      pieceType = stdin.readLineSync();
      if (['Cat', 'Kitten'].contains(pieceType)) {
        break;
      } else {
        print('That is not a valid piece type. Please input either "Cat" or "Kitten"');
      }
    }

    // input row
    while (true) {
      print('What row would you like to place the piece?');
      try {
        row = int.tryParse(stdin.readLineSync()!);
        // ignore: empty_catches
      } on Exception catch (e) {
        print('error: $e');
        print('please input a number from 0 to 5');
        continue;
      }
      if ([0, 1, 2, 3, 4, 5].contains(row)) {
        break;
      } else {
        print('please input a number from 0 to 5');
      }
    }

    // input column
    while (true) {
      print('What column would you like to place the piece?');
      try {
        column = int.tryParse(stdin.readLineSync()!);
        // ignore: empty_catches
      } on Exception catch (e) {
        print('error: $e');
        print('please input a number from 0 to 5');
        continue;
      }
      if ([0, 1, 2, 3, 4, 5].contains(column)) {
        break;
      } else {
        print('please input a number from 0 to 5');
      }
    }

    if (playerOneTurn) {
      winner = takeTurn(board, ralph, pieceType!, row!, column!);
      playerOneTurn = !playerOneTurn;
    } else {
      winner = takeTurn(board, jack, pieceType!, row!, column!);
      playerOneTurn = !playerOneTurn;
    }
    if (winner != null) {
      break;
    }

    print(board.grid);
  }

  print('$winner wins!');
}
