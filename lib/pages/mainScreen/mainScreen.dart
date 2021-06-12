import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/Shared/ui_elements/colors.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/pages/mainScreen/devTile.dart';
import 'package:snake/pages/mainScreen/gameTile.dart';
import 'package:snake/register/avatar.dart';
import 'package:snake/register/initialRegisterPage.dart';

import '../../Shared/data/const.dart';

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
            Expanded(
              flex: 8,
              child: TweenAnimationBuilder(
                  duration: Duration(seconds: 2),
                  tween: Tween<double>(begin: 0, end: 1),
                  // padding: val;

                  child: logoBanner(context),
                  builder: (BuildContext context, double _val, Widget child) {
                    return Opacity(
                        opacity: _val,
                        child: Padding(
                          padding: EdgeInsets.all(_val * 20),
                          child: child,
                        ));
                  }),
            ),
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
                for (int i = 0; i < 6; i++)
                  if (i != 3)
                    gameTile(context, i, currAvatar.username)
                  else
                    devTile(context, 3),
              ],
            ),
          ),
          // Expanded(flex: 3, child: leaderBoardButton(context))
        ],
      ),
    );
  }
}
