import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'utils.dart';

class ShakespeareDataSource implements DataSource {
  StreamController<List<String>> _controller = StreamController();
  get stream => _controller.stream;

  @override
  void fetch() {
    rootBundle.loadString("assets/hamlet.txt").then((s) =>
      _controller.add(s.split("\n"))
    );
  }

  @override
  void dispose() {
    _controller.close();
  }
}

class RemoteCommentData implements DataSource {
  RemoteCommentData({this.lineNum});
  final lineNum;
  StreamController<String> _controller = StreamController();
  get stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<Null> fetch() async {
    try {
      var response = await http.get("http://newfivefour.com:4040/get?line=$lineNum");
      _controller.add((response.body == null) ? "" : response.body);
    } catch(e) {
      _controller.add("An error has occurred!");
    }
  }

  void saveComment(lineNum, text) async {
    try {
      await http.get("http://newfivefour.com:4040/add"
          "?line=$lineNum"
          "&comment=${Uri.encodeComponent(text)}");
      fetch();
    } catch(e) {
      _controller.add("An error has occurred!");
    }
  }
}