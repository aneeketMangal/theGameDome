import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake/chat/model/http_model.dart';
import 'package:snake/chat/service/http_service.dart';

class ChatRoom extends StatefulWidget {
  String userName;
  ChatRoom(String userName) {
    this.userName = userName;
  }
  @override
  _ChatRoomState createState() => _ChatRoomState(userName);
}

class _ChatRoomState extends State<ChatRoom> {
  final HttpService httpService = HttpService();
  Timer timer;
  final TextEditingController titleController = TextEditingController();
  // ScrollController _scrollController = ScrollController();
  _ChatRoomState(String userName);
  Widget messageInput(TextEditingController control, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: TextField(
        showCursor: false,
        textAlign: TextAlign.center,
        controller: control,
        style: Theme.of(context).textTheme.headline2,
        onChanged: (value) {
          debugPrint('Something changed in Title Text Field');
          // updateTitle();
        },
        decoration: InputDecoration.collapsed(
            hintText: "type here",
            hintStyle: Theme.of(context).textTheme.headline2),
      ),
    );
  }

  Future<void> login() async {
    await httpService.login();
  }

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 4), (Timer t) {
      if (mounted) setState(() {});
      // _scrollToBottom();
    });
    login();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: new Text(
          "chatRoom",
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: httpService.getPosts(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.hasData) {
                  List<Post> posts = snapshot.data;
                  return ListView(
                    // controller: _scrollController,
                    children: posts
                        .map(
                          (Post post) => ListTile(
                            title: Text(post.user),
                            subtitle: Text(post.body),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  print("waiting2");
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ));
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: messageInput(titleController, context),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.restore_page),
                      onPressed: () {
                        debugPrint("ha;;");
                        login();
                      }),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        httpService.sendPosts(
                            widget.userName, titleController.text);
                        titleController.clear();
                        if (mounted) setState(() {});
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
