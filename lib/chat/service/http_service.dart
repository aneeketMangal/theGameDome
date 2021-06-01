import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snake/chat/model/http_model.dart';

class HttpService {
  final String room = "tempUser";
  final String baseURL = "https://aneeket.pythonanywhere.com/";

  // "https://aneeket.pythonanywhere.com/recieve?name=tempUser";
  // final String loginURL = ;

  Future<List<Post>> getPosts() async {
    await login();
    String recieveURL = baseURL + "recieve?name=" + room;
    final uri = Uri.parse(recieveURL);
    print(uri);
    http.Response res = await http.get(uri);
    print("trying");
    print(res.statusCode);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw "Server Error";
    }
  }

  Future<int> sendPosts(String user, String message) async {
    String sendURL =
        baseURL + "send?name=" + room + "&user=" + user + "&message=" + message;
    final uri = Uri.parse(sendURL);
    http.Response res = await http.get(uri);

    if (res.statusCode == 200) {
      return 1;
    } else {
      throw "Server Error";
    }
  }

  Future<int> login({String roomU = "tempUser"}) async {
    String sendURL = baseURL + "login/" + roomU;
    final uri = Uri.parse(sendURL);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      return 1;
    } else {
      throw "Server Error";
    }
  }
}
