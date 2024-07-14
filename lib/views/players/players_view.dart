import 'package:flutter/material.dart';
import 'package:volleylytics/globals.dart';

import '../../models/player.dart';
import 'player_editor_view.dart';


class PlayersView extends StatefulWidget {
  const PlayersView({super.key});

  @override
  State<PlayersView> createState() => _PlayersViewState();
}

class _PlayersViewState extends State<PlayersView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Players"),
      ),
      body: ListView.builder(
          itemCount: globals.playerProvider.players.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  if (globals.playerProvider.players[index].isCaptain)
                    Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                  Text("${globals.playerProvider.players[index].firstName} ${globals.playerProvider.players[index].secondName}", style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
              subtitle: Text("Display: ${globals.playerProvider.players[index].displayName}", style: Theme.of(context).textTheme.labelLarge,),
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                padding: const EdgeInsets.all(6),
                child: Text(globals.playerProvider.players[index].position?.getIndicationLetter() ?? "?", style: Theme.of(context).textTheme.displaySmall,),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(globals.playerProvider.players[index].number, style: Theme.of(context).textTheme.displaySmall),
              ),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerEditorView(editIndex: index,)));
                setState(() {});
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlayerEditorView()));
          setState(() {});
        },
      ),
    );
  }
}
