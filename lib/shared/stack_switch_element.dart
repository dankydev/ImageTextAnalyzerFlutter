import 'package:flutter/material.dart';

class StackSwitchElement extends StatefulWidget {
  final String title;
  final bool switchActivated;
  final Function(bool) onSwitchChanged;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final Color activeColor;
  final Size size;
  final BorderRadiusGeometry borderRadius;

  StackSwitchElement(
      {Key key,
      this.title,
      this.switchActivated,
      this.onSwitchChanged,
      this.top,
      this.bottom,
      this.left,
      this.right,
      this.activeColor,
      this.size,
      this.borderRadius})
      : super(key: key);

  @override
  _StackSwitchElementState createState() => _StackSwitchElementState();
}

class _StackSwitchElementState extends State<StackSwitchElement> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      right: widget.right,
      left: widget.left,
      bottom: widget.bottom,
      child: Container(
        width: widget.size.width,
        decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: Colors.black.withOpacity(0.75)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(widget.title),
            Switch(
              activeColor: widget.activeColor,
              value: widget.switchActivated,
              onChanged: widget.onSwitchChanged,
            )
          ],
        ),
      ),
    );
  }
}
