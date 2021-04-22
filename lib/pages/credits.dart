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
          "attributions",
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0.0,
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
        children: <Widget>[
          for (int i = 0; i < 4; i++) gameTile(context, i),
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
