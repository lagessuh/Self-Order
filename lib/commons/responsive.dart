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

  // static bool isMobile(BuildContext context) =>
  //     MediaQuery.of(context).size.width < 800;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width >= 320 &&
      MediaQuery.of(context).size.width < 501;

  // static bool isTablet(BuildContext context) =>
  //     MediaQuery.of(context).size.width >= 800 &&
  //     MediaQuery.of(context).size.width < 1100;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 501 &&
      MediaQuery.of(context).size.width < 768;

  static bool isLaptop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  // static bool isDesktop(BuildContext context) =>
  //     MediaQuery.of(context).size.width >= 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  // @override
  // Widget build(BuildContext context) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       if (constraints.maxWidth >= 1100) {
  //         return desktop!;
  //       } else if (constraints.maxWidth >= 800) {
  //         return tablet ?? mobile!;
  //       } else {
  //         return mobile!;
  //       }
  //     },
  //   );
  // }
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

// import 'package:flutter/material.dart';

// class Responsive extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget desktop;

//   const Responsive({
//     Key? key,
//     required this.mobile,
//     this.tablet,
//     required this.desktop,
//   }) : super(key: key);

// // This size work fine on my design, maybe you need some customization depends on your design

//   // This isMobile, isTablet, isDesktop help us later
//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 850;

//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width < 1100 &&
//       MediaQuery.of(context).size.width >= 850;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 1100;

//   @override
//   Widget build(BuildContext context) {
//     final Size _size = MediaQuery.of(context).size;
//     // If our width is more than 1100 then we consider it a desktop
//     if (_size.width >= 1100) {
//       return desktop;
//     }
//     // If width it less then 1100 and more then 850 we consider it as tablet
//     else if (_size.width >= 850 && tablet != null) {
//       return tablet!;
//     }
//     // Or less then that we called it mobile
//     else {
//       return mobile;
//     }
//   }
// }

// // import 'package:flutter/material.dart';

// // class Responsive extends StatelessWidget {
// //   final Widget mobile;
// //   final Widget tablet;
// //   final Widget desktop;
// //   const Responsive({
// //     Key? key,
// //     required this.desktop,
// //     required this.mobile,
// //     required this.tablet,
// //   }) : super(key: key);

// //   /// mobile < 650
// //   static bool isMobile(BuildContext context) =>
// //       MediaQuery.of(context).size.width < 650;

// //   /// tablet >= 650
// //   static bool isTablet(BuildContext context) =>
// //       MediaQuery.of(context).size.width >= 650;

// //   ///desktop >= 1100
// //   static bool isDesktop(BuildContext context) =>
// //       MediaQuery.of(context).size.width >= 1100;

// //   @override
// //   Widget build(BuildContext context) {
// //     return LayoutBuilder(builder: (context, constraints) {
// //       if (constraints.maxWidth >= 1100) {
// //         return desktop;
// //       } else if (constraints.maxWidth >= 650) {
// //         return tablet;
// //       } else {
// //         return mobile;
// //       }
// //     });
// //   }
// // }
