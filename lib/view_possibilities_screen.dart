import 'package:boop/grid.dart';
import 'package:boop/possibility.dart';
import 'package:flutter/material.dart';

class ViewPossibilitiesScreen extends StatefulWidget {
  final List<Possibility> possibilities;
  final Function refreshMyGamePageState;
  final Function alternatePlayerOneTurn;
  final bool playerOneTurn;
  final String? winner;
  const ViewPossibilitiesScreen({
    super.key,
    required this.possibilities,
    required this.refreshMyGamePageState,
    required this.alternatePlayerOneTurn,
    required this.playerOneTurn,
    required this.winner,
  });

  @override
  State<ViewPossibilitiesScreen> createState() => _ViewPossibilitiesScreenState();
}

class _ViewPossibilitiesScreenState extends State<ViewPossibilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    Possibility possibilityOne = widget.possibilities[0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Grid(
          board: possibilityOne.futureBoard,
          playerOne: possibilityOne.player,
          playerTwo: possibilityOne.otherPlayer,
          refreshMyGamePageState: widget.refreshMyGamePageState,
          alternatePlayerOneTurn: widget.alternatePlayerOneTurn,
          playerOneTurn: widget.playerOneTurn,
          winner: widget.winner,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () {}, child: const Text(">")),
            const SizedBox(width: 50),
            TextButton(onPressed: () {}, child: const Text("<")),
          ],
        ),
      ],
    );
  }
}
