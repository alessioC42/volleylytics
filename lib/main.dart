import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:volleylytics/globals.dart';
import 'package:volleylytics/providers/sams_provider.dart';
import 'package:volleylytics/views/matches_browser_view.dart';
import 'package:volleylytics/views/players/players_view.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                MaterialPageRoute(builder: (context) => const MatchesBrowserView()),
              );
            },
          ),
          ListTile(
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.ac_unit),
          onPressed: () async {
            SamsProvider samsProvider = SamsProvider();
            await samsProvider.initializeSocket();
            await Future.delayed(const Duration(seconds: 5));
            debugPrint(samsProvider.matchSeries.length.toString());
            samsProvider.closeSocket();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Player',
        child: const Icon(Icons.add),
      ),
    );
  }
}
