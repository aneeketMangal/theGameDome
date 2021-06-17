import 'package:flutter/cupertino.dart';

import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snake/Shared/preferences/preferences.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/database/models/game.dart';
import 'package:snake/database/utils/database_helper.dart';
import 'package:snake/register/avatar.dart';
import '../../Shared/data/const.dart';

class Hangman extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GameState();
  }
}

class GameState extends State<Hangman> {
  Hangman game = Hangman();
  DateTime initial;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int cap = 7;
  int playing = 0;

  TextEditingController titleController = TextEditingController();
  static Random rnd = new Random();
  String curr;
  int number;
  int c;
  List<String> currGame = ["_"];
  List<int> chosen = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _gameOver() {
    if (cap == 1) {
      playing = 2;
    }
    if (c <= 0) {
      playing = 1;
    }
  }

  void saveRecord() async {
    DateTime endtime = DateTime.now();
    Avatar currAvatarTemp = await readDataFromSharedPreferences();
    Game game = new Game.basic();
    game.gameId = 2;
    game.score = (endtime.difference(initial).inMilliseconds);
    game.score = game.score ~/ 90;
    game.username = currAvatarTemp.username;
    game.charPos = currAvatarTemp.avatarIndex;
    game.difficulty = 1;
    int result;

    result = await databaseHelper.insertGame(game);

    if (result != 0) {
      print("ho gaya sbji");
    } else {
      // Failure
      print("ae mereko to aisa dhak dhak ho rela h");
    }
  }

  void _newGame() {
    initial = DateTime.now();
    curr = names[rnd.nextInt(names.length)];
    number = curr.length;
    c = curr.length;
    print(curr);
    print(c);
    for (int i = 0; i < number; i++) {
      currGame.add("_");
    }
  }

  void _startNewGame() {
    Navigator.popAndPushNamed(context, "/third");
    // Navigator.pushNamedAndRemoveUntil(context, "/third", (r) => true);
  }

  void _onPress(int index) {
    if (chosen[index] == 0) {
      if (_trueValue(utf8.decode([index + 65]), context) && cap == 1) {
        _update(String.fromCharCodes([index + 65]), index);
      } else {
        _gameOver();
        _update(String.fromCharCodes([index + 65]), index);
      }
    }
  }

  Widget _correctWordDisplay() {
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        Text("The correct word was" + "\n",
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20)),
        Text(curr,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 26)),
        SizedBox(height: 26),
      ],
    );
  }

  Widget _alphabetKeys() {
    print(utf8.encode('A')[0] - 65);
    return new Wrap(
      spacing: 2,
      runSpacing: 2,
      alignment: WrapAlignment.center,
      children: alphabet
          .map((letter) => Container(
                height: 40,
                width: 40,
                child: RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Center(
                        child: Text(letter,
                            style: TextStyle(
                                fontSize: 25,
                                color:
                                    (chosen[utf8.encode(letter)[0] - 65] == 0)
                                        ? Theme.of(context).primaryColor
                                        : Colors.red[300]))),
                    onPressed: () {
                      print(chosen[utf8.encode(letter)[0] - 65] == 0);
                      _onPress(utf8.encode(letter)[0] - 65);
                    }),
              ))
          .toList(),
    );
  }

  Widget _fillBoxes() {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: 70,
        child: ListView.builder(
          itemCount: number,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => Row(
            children: <Widget>[
              new Container(
                  height: 40,
                  width: 30,
                  child: new Center(
                    child: new Text(currGame[index],
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontSize: 30)),
                  )),
              SizedBox(width: 2)
            ],
          ),
        ));
  }

  Widget _wonGame() {
    setState(() {
      saveRecord();
    });
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            child: Image.asset(Images[8]),
          ),
          _correctWordDisplay(),
          Container(
            width: 210,
            height: 50,
            child: RaisedButton(
                elevation: 0,
                child: Text("New Game",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 30)),
                onPressed: () {
                  _startNewGame();
                }),
          )
        ],
      ),
    );
  }

  Widget _loseGame() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            child: Image.asset(Images[7]),
          ),
          _correctWordDisplay(),
          Container(
            width: 180,
            height: 50,
            child: RaisedButton.icon(
                icon:
                    Icon(Icons.refresh, color: Theme.of(context).primaryColor),
                elevation: 0,
                label: Text("Restart",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 30)),
                onPressed: () {
                  _startNewGame();
                }),
          )
        ],
      ),
    );
  }

  Widget _mainScreen() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            height: 350,
            child: Image.asset(Images[7 - cap]),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                cap.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 70),
              ),
              Text("Chances", style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 80),
              Text(
                curr.length.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 70),
              ),
              Text("Letters", style: Theme.of(context).textTheme.headline2)
            ],
          ),
        )
      ],
    );
  }

  bool _trueValue(String letter, context) {
    for (int i = 0; i < number; i++) {
      if (letter == curr[i]) {
        return true;
      }
    }
    return false;
  }

  void _update(String word, int index) {
    this.setState(() {
      if (chosen[index] == 0) {
        chosen[index] = 1;
        if (!_trueValue(String.fromCharCodes([index + 65]), context)) {
          cap--;
        } else {
          for (int i = 0; i < number; i++) {
            if (String.fromCharCodes([index + 65])[0] == curr[i]) {
              currGame[i] = curr[i];

              --c;
              if (c == 0) {
                setState(() {
                  playing = 1;
                });
              }
            }
          }
        }
      }
    });
  }

  Widget build(BuildContext context) {
    if (playing == 0) {
      return Scaffold(
          appBar: themeAppBar(context, 2),
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(children: <Widget>[
                  _mainScreen(),
                  SizedBox(height: 10),
                  _fillBoxes(),
                  SizedBox(height: 20),
                  _alphabetKeys()
                ])),
          ));
    } else if (playing == 1) {
      return Scaffold(
          appBar: themeAppBar(context, 2),
          body: SingleChildScrollView(child: _wonGame()));
    } else {
      return Scaffold(
          appBar: themeAppBar(context, 2),
          body: SingleChildScrollView(child: _loseGame()));
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
