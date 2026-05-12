import 'package:flutter/widgets.dart';

class BoxShadows {
  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05), // rgba(0, 0, 0, 0.5)
      offset: Offset(2, 2), // 2px 2px
      blurRadius: 10, // 10px
      spreadRadius: 0, // 0px
    ),
  ];

  static const List<BoxShadow> shadow4 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06), // rgba(0, 0, 0, 0.06)
      offset: Offset(2, 2), // 2px 2px
      blurRadius: 20, // 20px
      spreadRadius: 0, // 0px
    ),
    // 두 번째 box-shadow
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04), // rgba(0, 0, 0, 0.04)
      offset: Offset(2, 2), // 2px 2px
      blurRadius: 10, // 10px
      spreadRadius: 0, // 0px
    ),
  ];

  // box-shadow: 2px 4px 12px 0px rgba(0, 0, 0, 0.10), 0px 0px 4px 0px rgba(0, 0, 0, 0.10);
  static const List<BoxShadow> shadow8 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.10),
      offset: Offset(2, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.10),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // box-shadow: 0px 4px 12px 0px rgba(0, 0, 0, 0.10), 4px 8px 28px 0px rgba(0, 0, 0, 0.04);
  static const List<BoxShadow> shadow16 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.10),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(4, 8),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];
}
