import 'dart:ui';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:volleylytics/views/editor/game_editor.dart';
import 'package:volleylytics/views/editor/game_setup.dart';
import 'package:volleylytics/views/sams/matches_browser_view.dart';
import 'package:volleylytics/views/players/players_view.dart';

import 'globals.dart';
import 'models/volleyball_match.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final List<SlidableController> _slidableControllers;

  void initSlidableControllers() {
    try {
      _slidableControllers.length;

      if (_slidableControllers.length < globals.matchProvider.matches.length) {
        _slidableControllers.addAll(
          List.generate(
            globals.matchProvider.matches.length - _slidableControllers.length,
                (index) => SlidableController(this),
          ),
        );
      } else if (_slidableControllers.length > globals.matchProvider.matches.length) {
        _slidableControllers.removeRange(globals.matchProvider.matches.length, _slidableControllers.length);
      }
    } catch (e) {
      _slidableControllers = List.generate(
        globals.matchProvider.matches.length,
            (index) => SlidableController(this),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initSlidableControllers();
  }

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
      body: globals.matchProvider.matches.isNotEmpty ? ListView.builder(
        itemCount: globals.matchProvider.matches.length,
        itemBuilder: (context, index) {
          final match = globals.matchProvider.matches[index];

          return Slidable(
            controller: _slidableControllers[index],
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                    icon: Icons.sports_volleyball,
                    onPressed: (context) async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameEditor(match: match),
                        ),
                      );

                    globals.matchProvider.saveMatches();

                    }),
                SlidableAction(
                  icon: Icons.analytics,
                  onPressed: (context) {

                  },
                  backgroundColor: Colors.blueAccent,
                ),
                SlidableAction(
                  icon: Icons.delete_forever,
                  onPressed: (context) async {
                    bool confirmed = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Match?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.network(match.teamWe.logoURL ?? ''),
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.network(match.teamThem.logoURL ?? ''),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(match.teamWe.name, style: Theme.of(context).textTheme.titleLarge),
                            Text('vs', style: Theme.of(context).textTheme.displayLarge),
                            Text(match.teamThem.name, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 20),
                            Text(DateFormat.yMMMd().format(match.startTime), style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed) {
                      setState(() {
                        globals.matchProvider.matches.removeAt(index);
                        globals.matchProvider.saveMatches();
                        initSlidableControllers();
                      });
                    }
                  },
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            child: ListTile(
              leading: Image.network(match.teamWe.logoURL ?? ''),
              title: Text('${match.teamWe.name} vs ${match.teamThem.name}'),
              subtitle: Text(globals.dateFormatter.format(match.startTime), style: Theme.of(context).textTheme.labelLarge),
              onTap: () {
                _slidableControllers[index].openEndActionPane();
              },
              trailing: Image.network(match.teamThem.logoURL ?? ''),
            ),
          );
        },
      ) : const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.sentiment_dissatisfied, size: 60),
                Padding(
                  padding: EdgeInsets.all(35),
                  child: Text('No matches found\n\nClick the + button to add a new match',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          )
        ],
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
                globals.matchProvider.saveMatches();
                initSlidableControllers();
              });
            }
          }
      ),
    );
  }
}
