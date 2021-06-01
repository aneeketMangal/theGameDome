import 'package:flutter/material.dart';
import 'package:snake/Shared/data/const.dart';
import 'package:snake/Shared/preferences/preferences.dart';
import 'package:snake/Shared/widgets/widgets.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
// <div>Icons made by <a href="https://www.flaticon.com/authors/surang" title="surang">surang</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

import 'package:snake/pages/mainScreen.dart';
import 'package:snake/register/avatar.dart';

class InitialRegister extends StatefulWidget {
  final Avatar currAvatar;

  const InitialRegister(this.currAvatar);
  @override
  _InitialRegisterState createState() => _InitialRegisterState();
}

class _InitialRegisterState extends State<InitialRegister> {
  Avatar currAvatar;
  int _focusedIndex;

  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    currAvatar = widget.currAvatar;
  }

  // Avatar loadingData() async {}
  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        characters[index],
        fit: BoxFit.cover,
        height: 250,
        width: 250,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: themeAppBar2(context, "register"),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("Set up your Avatar!!!",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(color: Colors.white, fontSize: 35)),
              )),
          Expanded(
            flex: 5,
            child: ScrollSnapList(
              onItemFocus: _onItemFocus,
              initialIndex: currAvatar.avatarIndex.toDouble(),
              itemSize: 250,
              itemBuilder: _buildListItem,
              itemCount: characters.length,
              selectedItemAnchor: SelectedItemAnchor.MIDDLE,
              dynamicItemOpacity: 0.2,
              duration: 1,
              // reverse: true,
              dynamicItemSize: true,
            ),
          ),

          Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: userNameInput(
                          titleController, context, currAvatar.username)),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          saveDataAndReturn();
                        }),
                  )
                ],
              ))
          // _buildItemDetail(),
        ],
      ),
    );
  }

  void saveDataAndReturn() async {
    String name = titleController.text;
    print(name);
    if (titleController.text == "") {
      name = currAvatar.username;
    }
    int val = _focusedIndex;
    if (val == null) {
      val = currAvatar.avatarIndex;
    }
    if (val == null) {
      val = 0;
    }

    print(val);
    if (name != null && val != null) {
      insertToSharedPreferences(val, name);

      print(val);
      print(name);
    }
    Avatar temp = await readDataFromSharedPreferences();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ConsoleScreen(temp)),
        (r) => false);
  }
}

Widget userNameInput(
    TextEditingController control, BuildContext context, String currName) {
  return Padding(
    padding: const EdgeInsets.only(left: 23.0),
    child: TextField(
      showCursor: false,
      textAlign: TextAlign.center,
      controller: control,
      style: Theme.of(context).textTheme.headline1,
      onChanged: (value) {
        debugPrint('Something changed in Title Text Field');
        // updateTitle();
      },
      decoration: InputDecoration.collapsed(
          hintText: currName, hintStyle: Theme.of(context).textTheme.headline1),
    ),
  );
}
