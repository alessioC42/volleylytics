import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../globals.dart';
import '../../models/player.dart';


class PlayerEditorView extends StatefulWidget {
  final int? editIndex;


  const PlayerEditorView({super.key, this.editIndex});

  @override
  State<PlayerEditorView> createState() => _PlayerEditorViewState();
}

class _PlayerEditorViewState extends State<PlayerEditorView> {
  late final bool isEditMode;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  bool isCaptain = false;
  PlayerPosition? position;

  @override void initState() {
    isEditMode = widget.editIndex != null;

    if (isEditMode) {
      final player = globals.playerProvider.players[widget.editIndex!];
      firstNameController.text = player.firstName;
      secondNameController.text = player.secondName;
      numberController.text = player.number;
      nicknameController.text = player.nickname??"";
      isCaptain = player.isCaptain;
      position = player.position;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text((isEditMode) ? "Edit Player" : "Create new Player"),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Player?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Are you sure you want to delete this player?", style: Theme.of(context).textTheme.labelLarge,),
                            Text("${globals.playerProvider.players[widget.editIndex!].firstName} ${globals.playerProvider.players[widget.editIndex!].secondName}, ${globals.playerProvider.players[widget.editIndex!].number}", style: Theme.of(context).textTheme.titleLarge,)
                          ]
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            globals.playerProvider.players.removeAt(widget.editIndex!);
                            globals.playerProvider.savePlayers(globals.playerProvider.players);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Delete"),
                        )
                      ],
                    );
                  }
                );
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(
                  labelText: "First Name"
              ),
            ),
            const SizedBox(height: 8,),
            TextFormField(
              controller: secondNameController,
              decoration: const InputDecoration(
                  labelText: "Second Name"
              ),
            ),
            const SizedBox(height: 8,),
            TextFormField(
              controller: nicknameController,
              decoration: const InputDecoration(
                  labelText: "Nickname (optional)"
              ),
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                        labelText: "Number"
                    ),
                  ),
                ),
                DropdownButton<PlayerPosition>(
                  value: position,
                  onChanged: (PlayerPosition? newValue) {
                    setState(() {
                      position = newValue;
                    });
                  },
                  items: [const DropdownMenuItem(value: null, child: Text("---")), ...PlayerPosition.values.map<DropdownMenuItem<PlayerPosition>>((PlayerPosition value) {
                    return DropdownMenuItem<PlayerPosition>(
                      value: value,
                      child: Text(value.getDisplayName()),
                    );
                  }).toList()],
                ),
                IconButton(onPressed: (){
                  setState(() {
                    if (!isCaptain && globals.playerProvider.doesCaptainExist()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There can only be one captain.")));
                      return;
                    }
                    isCaptain = !isCaptain;
                  });
                }, icon: isCaptain ? const Icon(Icons.star, color: Colors.yellow,) : const Icon(Icons.star_border),
                iconSize: 35,
                ),
              ],
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () {
                //validate inputs
                if (firstNameController.text.trim() == "" || secondNameController.text.trim() == "" || numberController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill out all fields")));
                  return;
                }

                final newPlayer = Player(
                  firstName: firstNameController.text.trim(),
                  secondName: secondNameController.text.trim(),
                  number: numberController.text,
                  nickname: nicknameController.text.trim() == "" ? null : nicknameController.text.trim(),
                  isCaptain: isCaptain,
                  position: position,
                );

                if (isEditMode) {
                  globals.playerProvider.players[widget.editIndex!] = newPlayer;
                } else {
                  globals.playerProvider.players.add(newPlayer);
                }
                globals.playerProvider.savePlayers(globals.playerProvider.players);

                Navigator.of(context).pop();
              },
              child: const Text("Save Player"),
            )
          ],
        ),
      ),

    );
  }
}
