import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

typedef Widget IndexedItemBuilder(BuildContext, int);
enum FlipDirection { up, down }
class FlipPanel<T> extends StatefulWidget {
  final IndexedItemBuilder? indexedItemBuilder;
  final int? itemsCount;
  final Duration? period;
  final Duration? duration;
  final int? loop;
  final int? startIndex;
  final T? initValue;
  final double? spacing;
  final FlipDirection? direction;

  const FlipPanel({
    Key? key,
    this.indexedItemBuilder,
    this.itemsCount,
    this.period,
    this.duration,
    this.loop,
    this.startIndex,
    this.initValue,
    this.spacing,
    this.direction,
  }) : super(key: key);

  FlipPanel.builder({
    Key? key,
    required IndexedItemBuilder itemBuilder,
    required this.itemsCount,
    required this.period,
    this.duration = const Duration(milliseconds: 500),
    this.loop = 1,
    this.startIndex = 0,
    this.spacing = 0.5,
    this.direction = FlipDirection.up,
  })  :indexedItemBuilder = itemBuilder,
        initValue = null,
        super(key: key);

  @override
  _FlipPanelState<T> createState() => _FlipPanelState<T>();
}



class _FlipPanelState<T> extends State<FlipPanel> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  int? _currentIndex;
  bool? _isReversePhase;
  bool? _running;
  final _perspective = 0.003;
  final _zeroAngle = 0.0001;
  int? _loop;
  T? _currentValue, _nextValue;
  Timer? _timer;
  StreamSubscription<T>? _subscription;

  Widget? _child1, _child2;
  Widget? _upperChild1, _upperChild2;
  Widget? _lowerChild1, _lowerChild2;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _isReversePhase = false;
    _running = false;
    _loop = 0;
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isReversePhase = true;
          _controller!.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          _currentValue = _nextValue;
          _running = false;
        }
      })
      ..addListener(() {
        setState(() {
          _running = true;
        });
      });
    _animation = Tween(begin: _zeroAngle, end: math.pi / 2).animate(_controller!);

    if (widget.period != null) {
      _timer = Timer.periodic(widget.period!, (_) {
        if (widget.loop! < 0 || _loop! < widget.loop!) {
          if (_currentIndex! + 1 == widget.itemsCount! - 2) {
            int value = _loop!;
            value++;
            _loop = value;
          }
          _currentIndex = (_currentIndex! + 1) % widget.itemsCount!;
          _child1 = null;
          _isReversePhase = false;
          _controller!.forward();
        } else {
          _timer!.cancel();
          _currentIndex = (_currentIndex! + 1) % widget.itemsCount!;
          setState(() {
            _running = false;
          });
        }
        _controller!.forward();
      });
    }
  }
  @override
  void dispose() {
    _controller!.dispose();
    if (_subscription != null) _subscription!.cancel();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildChildWidgetsIfNeed(context);

    return _buildPanel();
  }

  void _buildChildWidgetsIfNeed(BuildContext context) {
    Widget makeUpperClip(Widget widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }

    Widget makeLowerClip(Widget widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }

    if (_running!) {
      if (_child1 == null) {
        _child1 = _child2 ??
            widget.indexedItemBuilder!(
            context, _currentIndex! % widget.itemsCount!);
        _child2 = null;
        _upperChild1 =
        _upperChild2 ?? makeUpperClip(_child1!);
        _lowerChild1 =
        _lowerChild2 ?? makeLowerClip(_child1!);
      }
      if (_child2 == null) {
        _child2 = widget.indexedItemBuilder!(
            context, (_currentIndex! + 1) % widget.itemsCount!);
        _upperChild2 = makeUpperClip(_child2!);
        _lowerChild2 = makeLowerClip(_child2!);
      }
    } else {
      _child1 = _child2 ?? widget.indexedItemBuilder!(
          context, _currentIndex! % widget.itemsCount!);
      _upperChild1 =
      _upperChild2 ?? makeUpperClip(_child1!);
      _lowerChild1 =
      _lowerChild2 ?? makeLowerClip(_child1!);
    }
  }

  Widget _buildUpperFlipPanel() => widget.direction == FlipDirection.up
      ? Stack(
    children: [
      Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, _perspective)
            ..rotateX(_zeroAngle),
          child: _upperChild1
      ),
      Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateX(_isReversePhase! ? _animation!.value : math.pi / 2),
        child: _upperChild2,
      ),
    ],
  )
      : Stack(
    children: [
      Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, _perspective)
            ..rotateX(_zeroAngle),
          child: _upperChild2
      ),
      Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateX(_isReversePhase! ? math.pi / 2 : _animation!.value),
        child: _upperChild1,
      ),
    ],
  );

  Widget _buildLowerFlipPanel() => widget.direction == FlipDirection.up
      ? Stack(
    children: [
      Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, _perspective)
            ..rotateX(_zeroAngle),
          child: _lowerChild2
      ),
      Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateX(_isReversePhase! ? math.pi / 2 : -_animation!.value),
        child: _lowerChild1,
      )
    ],
  )
      : Stack(
    children: [
      Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, _perspective)
            ..rotateX(_zeroAngle),
          child: _lowerChild1
      ),
      Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, _perspective)
          ..rotateX(_isReversePhase! ? -_animation!.value : math.pi / 2),
        child: _lowerChild2,
      )
    ],
  );

  Widget _buildPanel() {
    return _running!
        ? Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUpperFlipPanel(),
        Padding(
          padding: EdgeInsets.only(top: widget.spacing!),
        ),
        _buildLowerFlipPanel(),
      ],
    ) : Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, _perspective)
              ..rotateX(_zeroAngle),
            child: _upperChild1
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.spacing!),
        ),
        Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, _perspective)
              ..rotateX(_zeroAngle),
            child: _lowerChild1
        )
      ],
    );
  }
}
