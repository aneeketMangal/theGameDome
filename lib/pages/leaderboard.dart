import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:snake/Shared/data/const.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/database/models/game.dart';
import 'package:snake/database/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GameList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GameListState();
  }
}

class GameListState extends State<GameList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Game> gameList;
  int count = 0;
  Random rnd = new Random();

  @override
  Widget build(BuildContext context) {
    if (gameList == null) {
      gameList = List<Game>();
      updateListView();
    }
    return Scaffold(
      appBar: themeAppBar2(context, "leaderboard"),
      body: getGameListView(),
      // body: Column(
      //   children: [
      //     recordTile(context, 0, gameList[0]),
      //     recordTile(context, 1, gameList[1]),
      //     recordTile(context, 2, gameList[2]),
      //     // Expanded(flex: 2, child: recordTile(context, 3, gameList[3])),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   // isExtended: true,
      //   child: Icon(Icons.sanitizer_rounded),
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     setState(() {
      //       _save();
      //     });
      //   },
      // ),
    );
  }

  ListView getGameListView() {
    print(count);
    return ListView.builder(
      itemCount: gameList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: recordTile(context, index, gameList[index]),
        );
      },
    );
  }

  void _save() async {
    Game game = new Game.basic();
    game.gameId = 2;
    game.score = 15;
    game.username = "aneeket";
    game.charPos = 9;
    game.difficulty = 2;
    int result;

    result = await databaseHelper.insertGame(game);

    if (result != 0) {
      print("ho gaya sbji");
    } else {
      // Failure
      print("ae mereko to aisa dhak dhak ho rela h");
    }
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Game>> gameListFuture = databaseHelper.getSortedGameList();

      gameListFuture.then((gameList) {
        setState(() {
          print("jljlkjjkl");
          print(gameList.length);
          this.gameList = gameList;
          this.count = gameList.length;
        });
      });
    });
  }
}

Widget recordTile(BuildContext context, int position, Game game) {
  return Card(
    elevation: 8.0,
    color: appColors[game.difficulty],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Image.asset(
                characters[game.charPos],
                fit: BoxFit.cover,
              ),
            )),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Text(
                  game.username,
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text(
                  "score: " + game.score.toString(),
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Image.asset(
                gameImage[game.gameId],
                fit: BoxFit.cover,
              ),
            )),
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}
