import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:volleylytics/globals.dart';
import 'package:volleylytics/views/editor/game_editor.dart';
import 'package:volleylytics/views/editor/game_setup.dart';
import 'package:volleylytics/views/sams/matches_browser_view.dart';
import 'package:volleylytics/views/players/players_view.dart';

import 'models/volleyball_match.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  globals.initializeGlobals();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolleyLytics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'VolleyLytics'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const Image(
              image: AssetImage('assets/images/volleyball.jpg'),
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            title: const Text('Players'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayersView()),
              );
            },
          ),
          ListTile(
            title: const Text('SAMS Matches'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MatchesBrowserView()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: globals.matchProvider.matches.length,
        itemBuilder: (context, index) {
          final match = globals.matchProvider.matches[index];
          return ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(match.teamThem.logoURL ?? (match.teamWe.logoURL ?? '')),
            ),
            title: Text('${match.teamWe.name} vs ${match.teamThem.name}'),
            subtitle: Text(match.startTime.toString()),
            onTap: () async {
              VolleyballMatch? overwrittenMatch = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameEditor(match: match),
                ),
              );

              if (overwrittenMatch != null) {
                setState(() {
                  globals.matchProvider.matches[index] = overwrittenMatch;
                  globals.matchProvider.saveMatches(globals.matchProvider.matches);
                });
              }
            },
            trailing: IconButton(
              icon: const Icon(Icons.bubble_chart),
              onPressed: () {
                throw UnimplementedError('Analytics dashboard not implemented yet');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          VolleyballMatch? result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GameSetup(),
            ),
          );
          if (result != null) {
            setState(() {
              globals.matchProvider.matches.add(result);
              globals.matchProvider.saveMatches(globals.matchProvider.matches);
            });
          }
        }
      ),
    );
  }
}
