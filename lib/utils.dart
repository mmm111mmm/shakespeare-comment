import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedValue extends StatefulWidget {
  final Function(BuildContext c, Animation<double> a) builder;
  final Function(AnimationController ani) animation;
  final int delay;
  final int duration;
  AnimatedValue({key, this.builder, this.duration, this.animation, this.delay}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedValueState();
}

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

abstract class DataSource {
  void fetch();
  void dispose();
}

class DataSourceBuilder extends StatefulWidget {
  final DataSource ds;
  final StreamBuilder sb;
  DataSourceBuilder({this.sb, this.ds});

  @override
  State<StatefulWidget> createState() => _DataSourceBuilderState();
}

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
  Widget build(BuildContext context) => widget.sb;
}

class Stateful extends StatefulWidget {
  final State state;
  Stateful(this.state, {key}) : super(key: key);
  @override createState() => state;
}