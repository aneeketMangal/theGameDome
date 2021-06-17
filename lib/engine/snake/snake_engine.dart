import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:snake/Shared/preferences/preferences.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/database/models/game.dart';
import 'package:snake/database/utils/database_helper.dart';
import 'package:snake/register/avatar.dart';

import '../../Shared/data/const.dart';

class SnakeGame extends StatefulWidget {
  SnakeGame();
  @override
  State<StatefulWidget> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  String direction;
  int rowLength;
  int columnLength;
  Queue<int> snake;
  int foodPosition;
  int max;
  int score;
  double speed;
  Duration delay;
  int recent;
  Timer _timer;
  String surpriseElement = '          Speed Control        ';
  // List<int> loseTrain = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  Game game;
  @override
  void initState() {
    this._newGame(1);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget toggleButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Center(
                child: Text(
              surpriseElement,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 31),
            )),
          ),
          RawMaterialButton(
              constraints: BoxConstraints(minWidth: 50, maxWidth: 50),
              child: Center(
                  child: Text(
                difficultyHangman[recent],
                style: Theme.of(context).textTheme.headline4,
              )),
              fillColor: colorHangmanDifficulty[recent],
              // shape: CircleBorder(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
              hoverElevation: 8.0,
              onPressed: () {
                setState(() {
                  surpriseElement = '          Speed Control        ';
                  int temp = (recent + 1) % 3;
                  print(temp);
                  _timer.cancel();
                  _newGame(temp);

                  recent = temp;
                });
              }),
        ],
      ),
    );
  }

  void _newGame(int temp) {
    score = 0;
    snake = Queue();
    snake.add(5);
    snake.add(25);
    snake.add(45);
    snake.add(65);
    direction = "down";
    rowLength = 30;
    columnLength = 35;
    recent = temp;
    speed = ((8 / (recent + 3))).toDouble();
    max = rowLength * columnLength;
    foodPosition = getRandomFoodPosition(max);

    Duration delayed = Duration(milliseconds: 100 * speed.toInt());
    _timer = Timer.periodic(delayed, (time) {
      print(delayed);
      update();
    });
  }

  void update() {
    if (this.mounted) {
      int nextVal = 0;
      setState(() {
        switch (direction) {
          case "down":
            if (snake.last > rowLength * (columnLength - 1)) {
              nextVal = (snake.last - rowLength * (columnLength - 1));
            } else {
              nextVal = (snake.last + rowLength);
            }
            break;
          case "up":
            if (snake.last < rowLength) {
              nextVal = (snake.last + rowLength * (columnLength - 1));
            } else {
              nextVal = (snake.last - rowLength);
            }
            break;
          case "left":
            if (snake.last % rowLength == 0) {
              nextVal = (snake.last - 1 + rowLength);
            } else {
              nextVal = (snake.last - 1);
            }
            break;
          case "right":
            if ((snake.last + 1) % rowLength == 0) {
              nextVal = (snake.last - rowLength + 1);
            } else {
              nextVal = (snake.last + 1);
            }
            break;
        }
        if (snake.contains(nextVal)) {
          gameOver();
        } else {
          snake.add(nextVal);
          if (snake.last == foodPosition) {
            setState(() {
              score += 1;
            });
            foodPosition = getRandomFoodPosition(rowLength * columnLength);
          } else {
            snake.removeFirst();
          }
        }
      });
    }
  }

  void gameOver() {
    // saveRecord();
    _timer.cancel();
    setState(() {
      saveRecord();
      recent = 3;
      surpriseElement = "         Oh No!!!!!        ";
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: themeAppBar(context, 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 10,
              child: GestureDetector(
                  onTap: () {
                    if (direction != "up") {
                      direction = "down";
                    }
                  },
                  onDoubleTap: () {
                    if (direction != "down") {
                      direction = "up";
                    }
                  },
                  onVerticalDragUpdate: (details) {
                    if (direction != "up" && details.delta.dy > 0) {
                      direction = "down";
                    } else if (direction != "down" && details.delta.dy < 0) {
                      direction = "up";
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (direction != "left" && details.delta.dx > 0) {
                      direction = "right";
                      print(direction);
                    } else if (direction != "right" && details.delta.dx < 0) {
                      direction = "left";
                    }
                  },
                  child: Container(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rowLength * columnLength,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowLength,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (snake.contains(index)) {
                          return Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              color: Colors.blue,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          );
                        }
                        if (index == foodPosition) {
                          return Center(
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.green,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              color: Color(0xFFE6A268),
                            ),
                          );
                        }
                      },
                    ),
                  ))),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: toggleButton(),
            ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "score",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      score.toString(),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  ///fixed the bug that generated food in the  lobby of snake
  int getRandomFoodPosition(int max) {
    Random random = Random();
    return random.nextInt(max);
  }

  void saveRecord() async {
    Avatar currAvatarTemp = await readDataFromSharedPreferences();
    Game game = new Game.basic();
    game.gameId = 0;
    game.score = score;
    game.username = currAvatarTemp.username;
    game.charPos = currAvatarTemp.avatarIndex;
    game.difficulty = recent;
    int result;

    result = await databaseHelper.insertGame(game);

    if (result != 0) {
      print("ho gaya sbji");
    } else {
      // Failure
      print("ae mereko to aisa dhak dhak ho rela h");
    }
  }
}
