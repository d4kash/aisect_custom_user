// // import 'package:flutter/material.dart';
// // import 'package:simple_animations/simple_animations.dart';

// // class FadeAnimation extends StatelessWidget {
// //   final double delay;
// //   final Widget child;

// //   FadeAnimation(this.delay, this.child);

// //   @override
// //   Widget build(BuildContext context) {
// //     final tween = MultiTween([
// //       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
// //       Track("translateY").add(
// //         Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
// //         curve: Curves.easeOut)
// //     ]);

// //     return PlayAnimation(
// //       delay: Duration(milliseconds: (500 * delay).round()),
// //       duration: tween.duration,
// //       tween: tween,
// //       child: child,
// //       builder: (context, child, animation) => Opacity(
// //         opacity: animation["opacity"],
// //         child: Transform.translate(
// //           offset: Offset(0, animation["translateY"]),
// //           child: child
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

// enum AniProps { opacity, translateY }

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(
//     this.delay,
//     this.child,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTween<AniProps>()
//       ..add(
//         AniProps.opacity,
//         0.0.tweenTo(1.0),
//       )
//       ..add(AniProps.translateY, (-30.0).tweenTo(0.0), 500.milliseconds,
//           Curves.easeOut);
//     /*
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
//       Track("translateY").add(
//           Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
//           curve: Curves.easeOut)
//     ]);*/

//     return PlayAnimation<MultiTweenValues<AniProps>>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, child, value) => Opacity(
//         opacity: value.get(AniProps.opacity),
//         child: Transform.translate(
//             offset: Offset(0, value.get(AniProps.translateY)), child: child),
//       ),
//     );
//   }
// }
