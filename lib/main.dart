import 'package:flutter/material.dart';
import 'detail.dart'; 
import 'utils.dart'; 
import 'data.dart'; 

void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Shakespeare Comment',
      theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: _MyListWidget(title: "Shakespeare Comment"),
  );
}

class _MyListWidget extends StatelessWidget {
  _MyListWidget({this.title});
  final title;
  final will = ShakespeareDataSource();

  @override
  Widget build(BuildContext context) => 
    DataSourceBuilder(ds: will, sb:
      StreamBuilder(stream: will.stream(), initialData: [""], builder: (b, snap) =>
        CustomScrollView(slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: 
                Text(title, style: TextStyle( color: Colors.white)),
              background: 
                Image(fit: BoxFit.fitWidth, image: AssetImage('assets/listview-banner.jpg')
              ),
            ),
          ),
          SliverList(delegate: 
            SliverChildBuilderDelegate(
              (context, pos) => _buildRow(context, snap.data[pos], pos),
              childCount: snap.data.length,
            ),
          )
        ])
      )
    );

  Widget _buildRow(BuildContext context, String text, int pos) {
    return Container(color: Colors.white, child:
      GestureDetector(
        onTap: () =>
          Navigator.push(context, 
            MaterialPageRoute(builder: (c) => 
              DetailScreen(line: text, pos: pos)
            )
          ),
        child: 
          _ListItem(pos: pos, text: text)
      )
    );
  }
}

class _ListItem extends StatelessWidget {
  final pos;
  final text;
  _ListItem({this.pos, this.text});

  @override
  Widget build(BuildContext context) =>
    Hero(tag: "line" + pos.toString(), child:
      Card(child:
        ListTile(
         title: Text(text, style: TextStyle(fontSize: 18.0)),
        ),
      )
    );
}
