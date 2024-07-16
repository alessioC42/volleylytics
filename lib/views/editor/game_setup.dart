import 'package:flutter/material.dart';
import 'package:volleylytics/models/team_description.dart';

import '../../models/volleyball_match.dart';
import '../../widgets/club_icon_selector.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  TeamDescription teamWe = TeamDescription(name: '');
  TeamDescription teamThem = TeamDescription(name: '');
  DateTime startTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Match'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: ClubIconSelector(
              query: teamWe.name,
              onIconSelected: (String? imageUrl) {
                teamWe.logoURL = imageUrl;
              },
            ),
            title: const Text('You'),
            subtitle: TextField(
              onChanged: (value) {
                setState(() {
                  teamWe.name= value;
                });
              },
            ),
          ),
          ListTile(
            leading: ClubIconSelector(
              query: teamThem.name,
              onIconSelected: (String? imageUrl) {
                teamThem.logoURL = imageUrl;
              },
            ),
            title: const Text('Opponent'),
            subtitle: TextField(
              onChanged: (value) {
                setState(() {
                  teamThem.name = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Start Time'),
            subtitle: Text(startTime.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final DateTime? newStartTime = await showDatePicker(
                  context: context,
                  initialDate: startTime,
                  firstDate: DateTime.now().subtract(const Duration(days: 365*5)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                final TimeOfDay? newTimeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(startTime),
                );

                if (newStartTime != null && newTimeOfDay != null) {
                  setState(() {
                    startTime = DateTime(
                      newStartTime.year,
                      newStartTime.month,
                      newStartTime.day,
                      newTimeOfDay.hour,
                      newTimeOfDay.minute,
                    );
                  });
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop<VolleyballMatch>(context, VolleyballMatch(
                teamWe: teamWe,
                teamThem: teamThem,
                startTime: startTime,
              ));
            },
            child: const Text('Create Match'),
          ),
        ],
      ),
    );
  }
}
