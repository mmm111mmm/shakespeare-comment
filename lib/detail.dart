import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils.dart';
import 'data.dart'; 

class DetailScreen extends StatelessWidget {
  DetailScreen({key, this.line, this.pos}) 
    : commentDataSource = new RemoteCommentData(lineNum: pos), 
    super(key: key) ;
  final String line;
  final int pos;
  final DataSource commentDataSource;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: 
        AppBar(
          title: Text("Detail Screen", style: TextStyle(color: Colors.white)),
        ),
      body: 
        RefreshIndicator(onRefresh: commentDataSource.fetch, child:
          ListView(children: [
            Padding(padding: EdgeInsets.all(20.0), child:
              Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                _SeparatedText(pos: pos, text: line),
                Padding(padding: EdgeInsets.only(top: 50.0), child:
                  _CommentInput(dataSource: commentDataSource)
                )
              ])
            )
          ])
        )
    );
  }

class _SeparatedText extends StatelessWidget {  
  _SeparatedText({this.text, this.pos});
  
  final String text;
  final pos;
  
  @override
  Widget build(BuildContext context) =>
    //iHero(tag: "line"+pos.toString(), child: 
      Wrap(children:
        text.split(" ").map((s) =>
          _SingleSeparatedWord(word: s)
        ).toList(),
      );
    //);
}

class _SingleSeparatedWord extends StatelessWidget {
  _SingleSeparatedWord({this.word});
  final String word;
  String plainWord() => word.toLowerCase().replaceAll(",", "");

  @override
  Widget build(BuildContext context) =>
    GestureDetector(
      onTap: () =>
        launch("https://www.thefreedictionary.com/"+plainWord(),
          forceWebView: true),
      child: 
        Card(child: 
          Container(padding: EdgeInsets.all(10.0), child:
            AnimatedValue(duration: 500, delay: 500,
              animation: (con) =>  
                Tween(begin: 18.0, end: 30.0).animate(con),
              builder: (c, anim) => 
                Text(word, style: TextStyle(fontSize: anim.value))
            )
          )
        )
      );
}

class _CommentInput extends StatelessWidget{
  _CommentInput({this.dataSource});
  final DataSource dataSource; 
  final _textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) => 
    DataSourceBuilder(ds: dataSource, sb:
      StreamBuilder<DataSourceResult>(stream: dataSource.stream(), initialData: DataSourceResult(), builder: (b, snap) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child:
            Stack(alignment: AlignmentDirectional.center , children: [
              CircularProgressIndicator(value: snap.data.isLoading ? null : 0.0),
              Text(snap.data.data ?? "", style: TextStyle(fontSize: 22.0)),
              Text(snap.data.isError && snap.data.data == null ? "Server error" : "", style: TextStyle(fontSize: 22.0))
            ])
          ),
          TextField(maxLines: null, 
            decoration: InputDecoration(hintText: "Input your comment.."),
            controller: _textInputController
          ),
          Padding(padding: EdgeInsets.only(top: 10.0), child:
            RaisedButton(color: Colors.orange, textColor: Colors.white,
              child: 
                Text("Create comment"),
              onPressed: () {
                this.dataSource.push(_textInputController.text.trim());
                _textInputController.text = "";
              }
            )
          )
        ])
      )
    );
}