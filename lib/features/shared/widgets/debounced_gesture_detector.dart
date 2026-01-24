// import 'package:dazzify/core/util/debounce_util.dart';
// import 'package:flutter/material.dart';
//
// /// A debounced version of GestureDetector that prevents double-tap execution
// /// Use this widget as a drop-in replacement for GestureDetector when you want to prevent rapid taps
// class DebouncedGestureDetector extends StatelessWidget {
//   final Widget child;
//   final void Function()? onTap;
//   final void Function()? onDoubleTap;
//   final void Function()? onLongPress;
//   final void Function(TapDownDetails)? onTapDown;
//   final void Function(TapUpDetails)? onTapUp;
//   final void Function()? onTapCancel;
//   final HitTestBehavior? behavior;
//   final String? debounceKey;
//   final bool excludeSemantics;
//
//   const DebouncedGestureDetector({
//     super.key,
//     required this.child,
//     this.onTap,
//     this.onDoubleTap,
//     this.onLongPress,
//     this.onTapDown,
//     this.onTapUp,
//     this.onTapCancel,
//     this.behavior,
//     this.debounceKey,
//     this.excludeSemantics = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Create a unique key for debouncing onTap only
//     final key =
//         debounceKey ?? 'debounced_gesture_${this.key?.hashCode ?? hashCode}';
//
//     void Function()? debouncedOnTap;
//     if (onTap != null) {
//       debouncedOnTap = () => DebounceUtil.execute(key, onTap!);
//     }
//
//     return GestureDetector(
//       onTap: debouncedOnTap,
//       onDoubleTap: onDoubleTap,
//       onLongPress: onLongPress,
//       onTapDown: onTapDown,
//       onTapUp: onTapUp,
//       onTapCancel: onTapCancel,
//       behavior: behavior,
//       excludeSemantics: excludeSemantics,
//       child: child,
//     );
//   }
// }













