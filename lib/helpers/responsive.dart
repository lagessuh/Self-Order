import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? laptop;
  final Widget? desktop;
  final Widget? extraLarge;

  const Responsive(
      {super.key,
      @required this.mobile,
      this.tablet,
      @required this.desktop,
      this.laptop,
      this.extraLarge});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width >= 320 &&
      MediaQuery.of(context).size.width < 501;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 501 &&
      MediaQuery.of(context).size.width < 768;

  static bool isLaptop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return extraLarge!;
        } else if (constraints.maxWidth < 1200 &&
            constraints.maxWidth >= 1024) {
          return desktop ?? laptop!;
        } else if (constraints.maxWidth < 1024 && constraints.maxWidth >= 768) {
          return laptop ?? tablet!;
        } else {
          return mobile!;
        }
      },
    );
  }
}
