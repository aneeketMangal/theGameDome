import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
      fontFamily: 'Secret',
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      buttonColor: Color(0xFFE6AA58),
      accentColor: Color(0xFFE6AA58),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w900,
          color: Color(0xFFE6AA58),
        ),
        headline2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
        headline3: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.w900,
          color: Color(0xFFE6AA68),
        ),
        headline4: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
          color: Color(0xFFE6AA68),
        ),
        headline5: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE6AA58),
        ),
        headline6: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w300,
          color: Color(0xFFE6AA58),
        ),
      ));
}

TextStyle userNameTextStyle = TextStyle(
    fontSize: 90, color: primaryTextColor, fontWeight: FontWeight.w500);

TextStyle titleStyle =
    TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w900);

TextStyle hoursPlayedLabelTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle hoursPlayedTextStyle = TextStyle(
  fontSize: 28,
  color: secondaryTextColor,
  fontWeight: FontWeight.normal,
);

TextStyle headingOneTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle headingTwoTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade900,
  fontWeight: FontWeight.bold,
);

TextStyle bodyTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade600,
);

TextStyle newGameTextStyle =
    TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700);

TextStyle newGameNameTextStyle =
    TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700);

TextStyle playWhiteTextStyle =
    TextStyle(fontSize: 14, color: firstColor, fontWeight: FontWeight.w700);
