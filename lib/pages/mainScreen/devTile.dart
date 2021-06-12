import 'package:flutter/material.dart';
import 'package:snake/Shared/data/const.dart';

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
