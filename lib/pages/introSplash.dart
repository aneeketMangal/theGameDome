import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:snake/Shared/preferences/preferences.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:snake/pages/mainScreen.dart';
import 'package:snake/register/avatar.dart';
import 'package:snake/register/initialRegisterPage.dart';

class IntroSplash extends StatefulWidget {
  @override
  _IntroSplashState createState() => _IntroSplashState();
}

class _IntroSplashState extends State<IntroSplash> {
  Avatar currAvatar;
  int currAvatarIndex;
  bool firstTime;
  void initState() {
    super.initState();
    fetchUserDetails();
    checkIfFirstTime();
    startTime();
  }

  void checkIfFirstTime() async {
    bool temp = await firstTimeHandling();
    setState(() {
      firstTime = temp;
    });
  }

  void fetchUserDetails() async {
    Avatar currAvatarTemp = await readDataFromSharedPreferences();

    setState(() {
      currAvatar = currAvatarTemp;
      currAvatarIndex = currAvatar.avatarIndex;
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    if (firstTime == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InitialRegister(currAvatar),
        ),
        (r) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ConsoleScreen(currAvatar),
        ),
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoBannerAnimated(context),
            TypewriterAnimatedTextKit(
                // colors: appColors,
                speed: Duration(milliseconds: 200),
                text: ["Slay. Play. GG!!!"],
                textStyle: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontSize: 30),
                textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}
