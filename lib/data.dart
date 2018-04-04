import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'utils.dart';

class ShakespeareDataSource implements DataSource<Null> {
  StreamController<List<String>> _controller = StreamController();

  @override
  stream() => _controller.stream;

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

  @override
  void push(Null inupt) {}
}


class RemoteCommentData implements DataSource<String> {
  RemoteCommentData({this.lineNum});
  final lineNum;
  final StreamController<DataSourceResult> _controller = StreamController();

  @override
  stream() => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<Null> fetch() async {
    try {
      _controller.add(DataSourceResult.loading());
      var response = await http.get("http://newfivefour.com:4040/get?line=$lineNum");
      var r = (response.body == null) 
        ? DataSourceResult.error("Bad result") 
        : DataSourceResult.make(response.body);
      _controller.add(r);
    } catch(e) {
      _controller.add(DataSourceResult.error("An error has occurred!"));
    }
  }

  @override
  void push(String input) async {
    try {
      await http.get("http://newfivefour.com:4040/add"
          "?line=$lineNum"
          "&comment=${Uri.encodeComponent(input)}");
      fetch();
    } catch(e) {
      _controller.add(DataSourceResult.error("An error has occurred!"));
    }
  }
}