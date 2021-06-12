import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:snake/Shared/data/const.dart';
import 'package:snake/Shared/preferences/preferences.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/database/models/game.dart';
import 'package:snake/database/utils/database_helper.dart';
import 'package:snake/register/avatar.dart';

//Class representing a board tile
class BoardTile {
  bool isBomb;
  int aroundBomb;
  BoardTile({this.isBomb = false, this.aroundBomb = 0});
}

class Minesweeper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinesweeperState();
  }
}

class MinesweeperState extends State<Minesweeper>
    with SingleTickerProviderStateMixin {
  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime initial;
  int rowLength;
  int colLength;
  int losewin;
  int flagged;
  double height;
  double width;
  bool intro;
  int noOfFlags;
  bool gameOver;
  int noOfMines;
  Random rnd = new Random();
  List<List<BoardTile>> mainBoard;
  List<bool> openTiles;
  List<bool> flagTiles;
  List<int> list;
  int squaresLeft;
  int recent;
  AnimationController _controller;
  List<Animation> _colorAnimations;

  @override
  void initState() {
    super.initState();
    _newGame(16, 8, 16);
  }

  void _startNewGame() {
    Navigator.pushNamedAndRemoveUntil(context, "/second", (r) => false);
  }

  void saveRecord() async {
    DateTime endtime = DateTime.now();
    Avatar currAvatarTemp = await readDataFromSharedPreferences();
    Game game = new Game.basic();
    game.gameId = 0;
    game.score = (endtime.difference(initial).inMilliseconds);

    ///to be handled further
    game.username = currAvatarTemp.username;
    game.charPos = currAvatarTemp.avatarIndex;
    game.difficulty = recent % 3;

    await databaseHelper.insertGame(game);
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
              "              Level   ",
              style: Theme.of(context).textTheme.headline2,
            )),
          ),
          Positioned(
            child: RawMaterialButton(
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
                    int tempTemp = (recent + 1) % 3;
                    int temp = size[tempTemp];
                    print(temp);
                    _newGame(temp * 2, temp, bombPlacementAlgorithm(temp));
                    recent = tempTemp;
                  });
                }),
          ),
        ],
      ),
    );
  }

  int bombPlacementAlgorithm(int size) {
    return ((size * (size + size)) / 10).floor() + 4;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
        appBar: themeAppBar(context, 1),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 20),
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  elevation: 7,
                  color: Colors.orange[500],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      upperTab(),
                      boardUI(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void openTileHandler(int position) {
    openTiles[position] = true;
    _controller.forward();
    print(_controller.value);
  }

  //this function is a initializer
  void _newGame(int x, int y, int z) {
    initial = DateTime.now();
    rowLength = x;
    colLength = y;
    noOfFlags = 0;
    losewin = 0;
    intro = false;
    gameOver = false;
    noOfMines = z;
    recent = 1;
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _colorAnimations = [
      ColorTween(begin: Colors.blue[200], end: Colors.red).animate(_controller)
    ];
    _controller.addListener(() {
      setState(() {});
    });
    squaresLeft = rowLength * colLength;
    mainBoard = List.generate(rowLength, (i) {
      return List.generate(colLength, (j) {
        return BoardTile();
      });
    });
    openTiles = List.generate(rowLength * colLength, (i) {
      return false;
    });

    flagTiles = List.generate(rowLength * colLength, (i) {
      return false;
    });

    //this part is used to generate mines at random position
    //for this we create a list of all
    list = List<int>.generate(rowLength * colLength, (int index) => index);
    list.shuffle();
    for (int k = 0; k < noOfMines; k++) {
      int row = (list[k] / colLength).floor();
      int column = (list[k] % colLength);
      mainBoard[row][column].isBomb = true;
    }

    for (int i = 0; i < rowLength; i++) {
      for (int j = 0; j < colLength; j++) {
        if (i > 0 && j > 0) {
          if (mainBoard[i - 1][j - 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (i > 0) {
          if (mainBoard[i - 1][j].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (i > 0 && j < colLength - 1) {
          if (mainBoard[i - 1][j + 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (j > 0) {
          if (mainBoard[i][j - 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (j < colLength - 1) {
          if (mainBoard[i][j + 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (i < rowLength - 1 && j > 0) {
          if (mainBoard[i + 1][j - 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (i < rowLength - 1) {
          if (mainBoard[i + 1][j].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }

        if (i < rowLength - 1 && j < colLength - 1) {
          if (mainBoard[i + 1][j + 1].isBomb) {
            mainBoard[i][j].aroundBomb++;
          }
        }
      }
    }
  }
  //this function handles the tap on any minesweeper tile

  void _onClick(int i, int j) {
    setState(() {
      if (flagTiles[i * colLength + j]) {
        noOfFlags -= 1;
      }
      openTileHandler(i * colLength + j);
      // openTiles[] = true;
      squaresLeft = squaresLeft - 1;
    });

    if (i > 0) {
      if (mainBoard[i - 1][j].isBomb == false &&
          openTiles[((i - 1) * colLength) + j] != true) {
        if (mainBoard[i][j].aroundBomb == 0) {
          _onClick(i - 1, j);
        }
      }
    }

    if (j > 0) {
      if (mainBoard[i][j - 1].isBomb == false &&
          openTiles[(i * colLength) + j - 1] != true) {
        if (mainBoard[i][j].aroundBomb == 0) {
          _onClick(i, j - 1);
        }
      }
    }

    if (j < colLength - 1) {
      if (mainBoard[i][j + 1].isBomb == false &&
          openTiles[(i * colLength) + j + 1] != true) {
        if (mainBoard[i][j].aroundBomb == 0) {
          _onClick(i, j + 1);
        }
      }
    }

    if (i < rowLength - 1) {
      if (mainBoard[i + 1][j].isBomb == false &&
          openTiles[((i + 1) * colLength) + j] != true) {
        if (mainBoard[i][j].aroundBomb == 0) {
          _onClick(i + 1, j);
        }
      }
    }
    setState(() {});
  }

  Widget upperTab() {
    if (!gameOver) {
      return Container(
        height: (60 / 759.27) * height,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Colors.blue[500],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: toggleButton(),
            ),
            Text("💣 " + "$noOfMines",
                style: TextStyle(
                  fontSize: 20,
                )),
            Text("🚩 " + "$noOfFlags",
                style: TextStyle(
                  fontSize: 20,
                )),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      _newGame(recent, recent, bombPlacementAlgorithm(recent));
                    });
                  },
                ),
                IconButton(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  icon: Icon(
                    Icons.info,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      intro = !intro;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          color: Colors.blue[500],
          child: Center(
            child: Text("GAME OVER",
                style: TextStyle(
                  fontSize: (40 / 759.27) * height,
                )),
          ));
    }
  }

  Widget boardUI() {
    if (losewin == 0) {
      if (intro == true) {
        return Container(
            height: width + (width / 3),
            width: width,
            padding: EdgeInsets.only(
                top: (30 / 760) * height,
                right: (30 / 360) * width,
                left: (30 / 360) * width),
            color: Colors.blue[300],
            child: Text(
              "Instructions:-\n\n💣:- Mine\n🚩:- Flag\n\n1. Tap a tile to open it.\n2. Long press to flag a tile.\n3. Click Level indicator to toggle difficulty.\n4. Scroll to see more tiles.",
              style: TextStyle(fontSize: (18 / 759.27) * height),
            ));
      } else {
        return Container(
            height: width + (width / 3),
            width: width,
            color: Colors.blue[100],
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: colLength,
                ),
                itemCount: rowLength * colLength,
                itemBuilder: (context, position) {
                  int row = (position / colLength).floor();
                  int column = (position % colLength);
                  String char = ' ';
                  Color main = Colors.blue[200];
                  Color accent = Colors.blue[300];
                  if (openTiles[position]) {
                    main = Colors.blueGrey[
                        (mainBoard[row][column].aroundBomb + 1) * 100];
                    accent = Colors.blueGrey[
                        (mainBoard[row][column].aroundBomb + 1) * 100];
                    //accent = Colors.orange[100];

                    if (mainBoard[row][column].isBomb) {
                      char = "💣";
                      main = Colors.red[400];
                      accent = Colors.red[400];
                    } else {
                      if (mainBoard[row][column].aroundBomb != 0) {
                        char = mainBoard[row][column].aroundBomb.toString();
                      } else {
                        char = " ";
                      }
                    }
                  } else {
                    if (flagTiles[position]) {
                      char = "🚩";
                      main = Colors.green[300];
                      accent = Colors.green[300];
                    } else {
                      char = " ";
                    }
                  }

                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, _) {
                      return InkWell(
                        onLongPress: () {
                          if (openTiles[position] == false) {
                            setState(() {
                              noOfFlags +=
                                  ((flagTiles[position] == false) ? 1 : (-1));
                              flagTiles[position] = !flagTiles[position];
                            });
                          }
                        },
                        onTap: () async {
                          if (flagTiles[position]) {
                          } else {
                            if (mainBoard[row][column].isBomb) {
                              await Future.delayed(
                                  const Duration(milliseconds: 100), () {
                                setState(() {
                                  gameOver = true;
                                });
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 10), () {
                                setState(() {
                                  openTiles[position] = true;
                                });
                              });
                              for (int i = 0; i < noOfMines; i++) {
                                if (list[i] != position) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 10), () {
                                    setState(() {
                                      openTiles[list[i]] = true;
                                    });
                                  });
                                }
                              }

                              await Future.delayed(
                                  const Duration(milliseconds: 100), () {
                                setState(() {
                                  losewin = 1;
                                });
                              });
                            } else if (mainBoard[row][column].aroundBomb == 0) {
                              _onClick(row, column);
                            } else {
                              setState(() {
                                if (openTiles[position] == false) {
                                  squaresLeft = squaresLeft - 1;
                                }
                                openTiles[position] = true;
                              });
                              if (squaresLeft <= noOfMines) {
                                await Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  setState(() {
                                    gameOver = true;
                                  });
                                });

                                setState(() {
                                  losewin = 2;
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                          width: width / colLength,
                          height: (width + (width / 3)) / rowLength,
                          decoration: BoxDecoration(
                            // color: _colorAnimations[0].value,
                            color: ((row + column) % 2 == 0) ? main : accent,
                          ),
                          child: Center(
                              child: Text(char,
                                  style: TextStyle(
                                      fontSize: (30 / colLength) * 8))),
                        ),
                      );
                    },
                  );
                }));
      }
    } else {
      return Container(
          height: width + (width / 3),
          width: width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          color: Colors.blue[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  (losewin == 1)
                      ? "Ooopsie💣💣!!!\nYou stepped on a mine"
                      : "Hurrah!!!!You Won",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: (32 / 759.27) * height)),
              SizedBox(height: (20 / 759.27) * height),
              FlatButton.icon(
                color: Colors.blue[200],
                label: Text("New Game",
                    style: TextStyle(fontSize: (25 / 759.27) * height)),
                icon: Icon(
                  Icons.refresh,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    if (losewin == 0) {
                      saveRecord();
                      print("yipee");
                    } else {
                      print("you lost");
                    }
                    _startNewGame();
                  });
                },
              ),
            ],
          ));
    }
  }
}
