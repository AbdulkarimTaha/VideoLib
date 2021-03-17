import 'package:flutter/material.dart';

class DeviceUtil {
  final BuildContext context;

  DeviceUtil(this.context);

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double screenHeight({double extent = 1}) => mediaQuery.size.height * extent;

  double screenWidth({double extent = 1}) => mediaQuery.size.width * extent;

  double statusBarHeight() => mediaQuery.padding.top;

  double bottomBarHeight() => mediaQuery.padding.bottom;
}

class Helpers {
  static Matrix4 dashboardMatrix4(BuildContext context) {
    final DeviceUtil deviceUtil = DeviceUtil(context);
    return Matrix4.identity()
      ..translate(220.0, deviceUtil.screenHeight(extent: 0.13))
      ..scale(0.7);
  }

  static Matrix4 shadowMatrix4(BuildContext context) {
    final DeviceUtil deviceUtil = DeviceUtil(context);
    return Matrix4.identity()
      ..translate(195.0, deviceUtil.screenHeight(extent: 0.19))
      ..scale(0.68);
  }
}
