import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/Shared/ui_elements/colors.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/register/avatar.dart';
import 'package:snake/register/initialRegisterPage.dart';

import '../Shared/data/const.dart';

class ConsoleScreen extends StatefulWidget {
  final Avatar currAvatar;

  const ConsoleScreen(this.currAvatar);
  @override
  _ConsoleScreenState createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  int currAvatarIndex;
  Avatar currAvatar;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() {
    currAvatarIndex = widget.currAvatar.avatarIndex;
    currAvatar = widget.currAvatar;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: [
            Expanded(flex: 8, child: logoBanner(context)),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InitialRegister(currAvatar)),
                      (r) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.pink,
                    border: Border.all(
                      width: 5,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage(characters[currAvatarIndex]),
                    minRadius: 45,
                    maxRadius: 45,
                  ),
                ),
              ),
            ),
          ],
        ),

        backgroundColor: Colors.transparent,
        // centerTitle: true,
        toolbarHeight: 250,
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Center(
                      child: Text("Welcome, ",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white)),
                    ),
                    Text(currAvatar.username,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: firstColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              )),
          Expanded(
            flex: 10,
            child: GridView.count(
              padding: const EdgeInsets.only(top: 25, left: 2, right: 2),
              crossAxisSpacing: 0,
              mainAxisSpacing: 2,
              crossAxisCount: 2,
              children: <Widget>[
                for (int i = 0; i < 4; i++)
                  if (i != 3) gameTile(context, i) else devTile(context, 3),
              ],
            ),
          ),
          Expanded(flex: 3, child: leaderBoardButton(context))
        ],
      ),
    );
  }
}

Widget gameTile(BuildContext context, int position) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamedAndRemoveUntil(context, route[position], (r) => true);
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3.0,
        color: appColors[position],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Text(
                  gameName[position],
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Image.asset(
                gameImage[position],
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    ),
  );
}

Widget leaderBoardButton(BuildContext context) {
  return Center(
      child: Container(
          padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
          child: RaisedButton.icon(
            icon: Icon(Icons.sanitizer),
            label: Text("      LeaderBoad      ",
                style: Theme.of(context).textTheme.headline2),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/fifth", (r) => true);
            },
          )));
}

Widget devTile(BuildContext context, int position) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamedAndRemoveUntil(context, route[position], (r) => true);
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3.0,
        color: appColors[position],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Text(
                  gameName[position],
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/mtFace.jpg'),
                  minRadius: 45,
                  maxRadius: 45,
                ),
              ),
            ),
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    ),
  );
}
