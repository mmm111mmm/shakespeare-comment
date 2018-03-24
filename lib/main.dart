import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Shakespeare Comment',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyListWidget(title: "Shakespeare Comment"),
    );
}

class MyListWidget extends StatefulWidget {
  MyListWidget({key, this.title}) : super(key: key);

  final String title;

  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {

  var will = ["That can I;",
  "At least, the whisper goes so. Our last king,",
  "Whose image even but now appear'd to us,",
  "Was, as you know, by Fortinbras of Norway,",
  "Thereto prick'd on by a most emulate pride,",
  "Dared to the combat; in which our valiant Hamlet--",
  "For so this side of our known world esteem'd him--",
  "Did slay this Fortinbras; who by a seal'd compact,",
  "Well ratified by law and heraldry,",
  "Did forfeit, with his life, all those his lands",
  "Which he stood seized of, to the conqueror:",
  "Against the which, a moiety competent",
  "Was gaged by our king; which had return'd",
  "To the inheritance of Fortinbras,",
  "Had he been vanquisher; as, by the same covenant,",
  "And carriage of the article design'd,",
  "His fell to Hamlet. Now, sir, young Fortinbras,",
  "Of unimproved mettle hot and full,",
  "Hath in the skirts of Norway here and there",
  "Shark'd up a list of lawless resolutes,",
  "For food and diet, to some enterprise",
  "That hath a stomach in't; which is no other--",
  "As it doth well appear unto our state--",
  "But to recover of us, by strong hand",
  "And terms compulsatory, those foresaid lands",
  "So by his father lost: and this, I take it,",
  "Is the main motive of our preparations,",
  "The source of this our watch and the chief head",
  "Of this post-haste and romage in the land."];


  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverAppBar(
        pinned: true,
        expandedHeight: 250.0,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(widget.title,
            style: TextStyle( color: Colors.white)
          ),
          background: Image(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/listview-banner.jpg')
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, pos) => _buildRow(context, will[pos], pos),
          childCount: will.length,
        ),
      )
    ]
  );

  Widget _buildRow(BuildContext context, String text, int pos) {
    return
      Container(
          child: Hero(
              tag: "line" + pos.toString(),
              child: Card(
                child: ListTile(
                    title: Text(text),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (c) => DetailScreen(line: text, pos: pos)))
                ),
              )
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          )
      );
  }

}

class DetailScreen extends StatefulWidget {
  DetailScreen({key, this.line, this.pos}) : super(key: key);

  final String line;
  final int pos;

  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Detail Screen", style: TextStyle(color: Colors.white)),
        ),
        body: Hero(
              tag: "line"+widget.pos.toString(),
              child: Card(
                child: ListTile(
                    title: Text(widget.line),
                )
              )
          ),
      );
}