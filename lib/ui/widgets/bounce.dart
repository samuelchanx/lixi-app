import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  ///child widget to make animated
  final Widget child;

  ///on press call back function
  final VoidCallback onPressed;

  ///scale factor for different devices
  final double scaleFactor;

  ///Animation duration
  final Duration duration;

  ///check to stay on bottom or not
  final bool stayOnBottom;

  ///animation dissmissed value
  final double lowerBound;

  ///animation completion value
  final double upperBound;

  const BouncingButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleFactor = 1,
    this.lowerBound = 0.0,
    this.upperBound = 0.3,
    this.duration = const Duration(milliseconds: 100),
    this.stayOnBottom = false,
  });

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  ///Animation controller to toggle animation of widget
  late AnimationController _controller;
  late double _scale;
  final GlobalKey _childKey = GlobalKey();
  bool _isOutside = false;
  Widget get child => widget.child;
  VoidCallback get onPressed => widget.onPressed;
  double get scaleFactor => widget.scaleFactor;
  Duration get duration => widget.duration;
  bool get _stayOnBottom => widget.stayOnBottom;
  double get _lowerBound => widget.lowerBound;
  double get _upperBound => widget.upperBound;

  @override
  void initState() {
    ///listen for animation
    _controller = AnimationController(
      vsync: this,
      duration: duration,
      lowerBound: _lowerBound,
      upperBound: _upperBound,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  ///on widget update toggle animation
  @override
  void didUpdateWidget(BouncingButton oldWidget) {
    if (oldWidget.stayOnBottom != _stayOnBottom) {
      if (!_stayOnBottom) {
        _reverseAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  ///dispose animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - (_controller.value * scaleFactor);
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onLongPressEnd: (details) => _onLongPressEnd(details, context),
        onHorizontalDragEnd: _onDragEnd,
        onVerticalDragEnd: _onDragEnd,
        onHorizontalDragUpdate: (details) => _onDragUpdate(details, context),
        onVerticalDragUpdate: (details) => _onDragUpdate(details, context),
        child: Transform.scale(
          key: _childKey,
          scale: _scale,
          child: child,
        ),
      ),
    );
  }

  ///on press handle
  _triggerOnPressed() {
    onPressed();
  }

  ///toggle forward animation
  _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  ///toggle reverse animation
  _onTapUp(TapUpDetails details) {
    if (!_stayOnBottom) {
      Future.delayed(duration, () {
        _reverseAnimation();
      });
    }
    _triggerOnPressed();
  }

  _onDragUpdate(DragUpdateDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;
    _isOutside = _isOutsideChildBox(touchPosition);
  }

  _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      _triggerOnPressed();
    }

    _reverseAnimation();
  }

  _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      _triggerOnPressed();
    }
    _reverseAnimation();
  }

  ///reverse animation toggle
  _reverseAnimation() {
    if (mounted) {
      _controller.reverse();
    }
  }

  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox? childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (childRenderBox == null) {
      return true;
    }
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return (touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height);
  }
}
