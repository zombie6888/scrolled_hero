import 'package:flutter/material.dart';

class InsetsClipper extends CustomClipper<Rect> {
  final EdgeInsets _insets;
  InsetsClipper([this._insets = EdgeInsets.zero]);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0 + _insets.left, 0 + _insets.top,
        size.width - _insets.right, size.height - _insets.bottom);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}