import 'package:flutter/material.dart';

import '../models/volleyball_score.dart';

typedef OnScoreChanged = void Function(VolleyballScore score);

class VolleyballScoreEditor extends StatefulWidget {
  final VolleyballScore score;
  final OnScoreChanged? onScoreChanged;

  const VolleyballScoreEditor(
      {super.key, required this.score, this.onScoreChanged});

  @override
  State<VolleyballScoreEditor> createState() => _VolleyballScoreEditorState();
}

class _VolleyballScoreEditorState extends State<VolleyballScoreEditor> {
  GlobalKey setKey1 = GlobalKey();
  GlobalKey setKey2 = GlobalKey();


  RelativeRect getMenuPosition(GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return RelativeRect.fromLTRB(
      position.dx + renderBox.size.width - 3,
      position.dy + renderBox.size.height - 3,
      position.dx + renderBox.size.width,
      position.dy + renderBox.size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  widget.score.decrementWe();
                  widget.onScoreChanged?.call(widget.score);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.score.incrementWe();
                  widget.onScoreChanged?.call(widget.score);
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              key: setKey1,
              onTap: () {
                showMenu(context: context,
                  position: getMenuPosition(setKey1),
                  items: [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.remove,),
                          Text('Decrease'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          widget.score.decrementSetWe();
                          widget.onScoreChanged?.call(widget.score);
                        });
                      },
                    ),
                    PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.add,),
                            Text('Add'),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            widget.score.incrementSetWe();
                            widget.onScoreChanged?.call(widget.score);
                          });
                        }
                    ),
                  ],
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding:
                const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 4),
                child: Text(
                  widget.score.setScorewe.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                      Theme.of(context).textTheme.headlineSmall?.fontSize),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                widget.score.scoreWe.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    Theme.of(context).textTheme.headlineMedium?.fontSize),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                ':',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    Theme.of(context).textTheme.headlineMedium?.fontSize),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                widget.score.scoreThem.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium?.fontSize),
              ),
            ),
            InkWell(
              key: setKey2,
              onTap: () {
                showMenu(context: context,
                  position: getMenuPosition(setKey2),
                  items: [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.remove,),
                          Text('Decrease'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          widget.score.decrementSetThem();
                          widget.onScoreChanged?.call(widget.score);
                        });
                      },
                    ),
                    PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.add,),
                            Text('Add'),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            widget.score.incrementSetThem();
                            widget.onScoreChanged?.call(widget.score);
                          });
                        }
                    ),
                  ],
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding:
                const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.score.setScoreThem.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                      Theme.of(context).textTheme.headlineSmall?.fontSize),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  widget.score.decrementThem();
                  widget.onScoreChanged?.call(widget.score);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.score.incrementThem();
                  widget.onScoreChanged?.call(widget.score);
                });
              },
            ),
          ],
        )
      ],
    );
  }
}
