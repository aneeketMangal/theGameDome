import 'package:flutter/material.dart';
import 'package:snake/engine/hangman/hangman_engine.dart';
import 'package:snake/engine/minesweeper/minesweeper_engine.dart';
import 'package:snake/engine/snake/snake_engine.dart';
import 'package:snake/pages/introSplash.dart';
import 'package:snake/pages/leaderboard.dart';
import 'package:snake/Shared/ui_elements/textStyle.dart';
import 'pages/aboutMe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: darkTheme(context),
      darkTheme: darkTheme(context),
      initialRoute: '/zeroth',
      routes: {
        '/zeroth': (context) => IntroSplash(),
        '/first': (context) => SnakeGame(),
        '/second': (context) => Minesweeper(),
        '/third': (context) => Hangman(),
        '/fourth': (context) => About(),
        '/fifth': (context) => GameList(),
      },
    );
  }
}
