import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

///
/// We create a AnimationController for the given time,
/// and give that to a callback to create an Animation,
/// which we then start, and listen to it, updating our
/// State as we get new values, an we use a builder 
/// callback to build the children, giving that the 
/// Animation.
///
class AnimatedValue extends StatefulWidget {
  final Function(BuildContext c, Animation<double> a) builder;
  final Function(AnimationController ani) animation;
  final int delay;
  final int duration;
  AnimatedValue({key, this.builder, this.duration, this.animation, this.delay}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedValueState();
}

///
/// See AnimatedValue
///
class _AnimatedValueState extends State<AnimatedValue> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration), vsync: this);
    _animation = widget.animation(_controller)
      ..addListener(() {
        setState(() {});
     });
    Future.delayed(Duration(milliseconds: widget.delay), () => _controller?.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _animation);
}
///
/// Used in DataSourceBuilder
/// 
enum DataSourceState { Calm, Error, Loading, Loaded }
///
/// Used in DataSourceBuilder
/// 
class DataSourceResult<T> {
  static DataSourceResult loading() => DataSourceResult()
    ..state = DataSourceState.Loading
    ..err=null;
  static DataSourceResult error(e) => DataSourceResult()
    ..state = DataSourceState.Error
    ..err=e;
  static DataSourceResult make(dynamic d) => DataSourceResult()
    ..state = DataSourceState.Loaded
    ..err=null
    ..data=d;
  get isLoading => state == DataSourceState.Loading;
  get isError => state == DataSourceState.Error;
  String err;
  DataSourceState state = DataSourceState.Calm;
  T data;
}
///
/// Used in DataSourceBuilder
/// 
abstract class DataSource<I> {
  void fetch();
  void dispose();
  Stream stream();
  void push(I input);
}

///
/// Pass a DataSource and it will fetch() it and dispose() of it for you.
/// You then use the StreamBuilder to display the widgets.
///
class DataSourceBuilder extends StatefulWidget {
  final DataSource ds;
  final StreamBuilder sb;
  DataSourceBuilder({this.sb, this.ds});

  @override
  State<StatefulWidget> createState() => _DataSourceBuilderState();
}

///
/// See DataSourceBuilder
///
class _DataSourceBuilderState extends State<DataSourceBuilder> {

  @override
  void initState() {
    super.initState();
    widget.ds.fetch();
  }

  @override
  void dispose() {
    widget.ds.dispose();
    super.dispose();
  }

  @override
    void didUpdateWidget(DataSourceBuilder oldWidget) {
      super.didUpdateWidget(oldWidget);
      if(oldWidget != widget) widget.ds.fetch();
    }

  @override
  Widget build(BuildContext context) => widget.sb;
}

class Stateful extends StatefulWidget {
  final State state;
  Stateful(this.state, {key}) : super(key: key);
  @override createState() => state;
}