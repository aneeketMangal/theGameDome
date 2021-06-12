import 'package:flutter/material.dart';
import 'package:snake/Shared/data/const.dart';

import '../chat.dart';

Widget gameTile(BuildContext context, int position, String username) {
  return GestureDetector(
    onTap: () {
      if (position != 5)
        Navigator.pushNamedAndRemoveUntil(
            context, route[position], (r) => true);
      else
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return ChatRoom(username);
          }),
        );
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
              child: Hero(
                tag: gameImage[position],
                child: Image.asset(
                  gameImage[position],
                  fit: BoxFit.cover,
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
