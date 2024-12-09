import 'package:flutter/material.dart';

class CountController extends StatefulWidget {
  const CountController({
    super.key,
    required this.decrementIconBuilder,
    required this.incrementIconBuilder,
    required this.countBuilder,
    required this.count,
    required this.updateCount,
    this.stepSize = 1,
    this.min,
    this.max,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 25.0),
  });

  final Widget Function(bool enabled) decrementIconBuilder;
  final Widget Function(bool enabled) incrementIconBuilder;
  final Widget Function(int count) countBuilder;
  final int count;
  final Function(int) updateCount;
  final int stepSize;
  final int? min;
  final int? max;
  final EdgeInsetsGeometry contentPadding;

  @override
  _CountControllerState createState() => _CountControllerState();
}

class _CountControllerState extends State<CountController> {
  int get count => widget.count;
  int? get min => widget.min;
  int? get max => widget.max;
  int get stepSize => widget.stepSize;

  bool get decrement => min == null || count - stepSize >= min!;
  bool get increment => max == null || count + stepSize <= max!;

  void _decrementCounter() {
    if (decrement) {
      setState(() => widget.updateCount(count - stepSize));
    }
  }

  void _incrementCounter() {
    if (increment) {
      setState(() => widget.updateCount(count + stepSize));
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.contentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _decrementCounter,
              child: widget.decrementIconBuilder(decrement),
            ),
            const SizedBox(
              width: 5,
            ),
            widget.countBuilder(count),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: _incrementCounter,
              child: widget.incrementIconBuilder(increment),
            ),
          ],
        ),
      );
}
