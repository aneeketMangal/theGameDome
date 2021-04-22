import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:snake/Shared/data/const.dart';

AppBar themeAppBar(BuildContext context, int index) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Theme.of(context).primaryColor,
    ),
    backgroundColor: Colors.transparent,
    toolbarHeight: 80,
    elevation: 0.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 45,
            width: 40,
            child: Image.asset(gameImage[index]),
          ),
        ),
        Expanded(
          flex: 10,
          child: new Text(
            gameName[index],
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ],
    ),
  );
}

AppBar themeAppBar2(BuildContext context, String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Theme.of(context).primaryColor,
    ),
    backgroundColor: Colors.transparent,
    toolbarHeight: 80,
    elevation: 0.0,
    title: new Text(
      title,
      style: Theme.of(context).textTheme.headline1,
    ),
  );
}

Widget logoBanner(BuildContext context) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Image.asset(
          "assets/mainLogo.png",
          fit: BoxFit.cover,
        ),
      ),
      Expanded(
        flex: 1,
        child: new Text(
          "the\ngame\ndome.",
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 40),
        ),
      ),
    ],
  );
}

Widget logoBannerAnimated(BuildContext context) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Image.asset(
          "assets/mainLogo.png",
          fit: BoxFit.cover,
        ),
      ),
      Expanded(
        flex: 1,
        child: ColorizeAnimatedTextKit(
            colors: appColors,
            speed: Duration(milliseconds: 400),
            text: ["the\ngame\ndome."],
            textStyle:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 40),
            textAlign: TextAlign.start),
      ),
    ],
  );
}
