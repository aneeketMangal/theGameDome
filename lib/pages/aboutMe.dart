import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../Shared/data/const.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: new Text(
          "about me",
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Center(
              child: CircleAvatar(
                backgroundImage: ExactAssetImage('assets/mtFace.jpg'),
                minRadius: 30,
                maxRadius: 70,
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                    "Hey There!! I am Aneeket Mangal, A computer science sophomore at Indian Institute of Technology. I am a programming enthusiast, who loves to explore the depths of computing possibilities. A George Orwell fan and a poetry nerd, I wish to develop a poetic programming language. Suggest me a name for that on my socials. 😆",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontWeight: FontWeight.w100)),
              ))),
          Expanded(
            flex: 3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
              // crossAxisSpacing: 0,
              // mainAxisSpacing: 0,
              // crossAxisCount: 2,
              children: <Widget>[
                for (int i = 0; i < 4; i++) gameTile(context, i),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: RaisedButton(
                    child: Text("              Attributions              ",
                        style: Theme.of(context).textTheme.headline2),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Game icon vectors were taken from"),
                            content: InkWell(
                                child: new Text(
                                  'Vecteezy',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                ),
                                onTap: () =>
                                    launch('https://www.vecteezy.com/')),
                          );
                        },
                      );
                    },
                  ),
                ),
              )),
          Expanded(
            flex: 3,
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}

Widget gameTile(BuildContext context, int position) {
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 5,
        width: 70,
        child: SignInButton(
          buttonOfhandles[position],
          mini: true,
          onPressed: () => launch(socialHandles[position]),
        ),
      ),
    ),
  );
}
