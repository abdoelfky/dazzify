// import 'package:dazzify/core/util/debounce_util.dart';
// import 'package:flutter/material.dart';
//
// /// A debounced version of IconButton that prevents double-tap execution
// class DebouncedIconButton extends StatelessWidget {
//   final void Function()? onPressed;
//   final Widget icon;
//   final String? tooltip;
//   final Color? color;
//   final Color? focusColor;
//   final Color? hoverColor;
//   final Color? highlightColor;
//   final Color? splashColor;
//   final Color? disabledColor;
//   final double? iconSize;
//   final EdgeInsetsGeometry? padding;
//   final AlignmentGeometry? alignment;
//   final String? semanticLabel;
//   final bool autofocus;
//   final double? splashRadius;
//   final MouseCursor? mouseCursor;
//   final FocusNode? focusNode;
//   final bool? enableFeedback;
//   final ButtonStyle? style;
//   final bool isSelected;
//   final ButtonStyle? selectedIcon;
//   final VisualDensity? visualDensity;
//   final Size? constraints;
//   final String? debounceKey;
//
//   const DebouncedIconButton({
//     super.key,
//     required this.onPressed,
//     required this.icon,
//     this.tooltip,
//     this.color,
//     this.focusColor,
//     this.hoverColor,
//     this.highlightColor,
//     this.splashColor,
//     this.disabledColor,
//     this.iconSize,
//     this.padding,
//     this.alignment,
//     this.semanticLabel,
//     this.autofocus = false,
//     this.splashRadius,
//     this.mouseCursor,
//     this.focusNode,
//     this.enableFeedback,
//     this.style,
//     this.isSelected = false,
//     this.selectedIcon,
//     this.visualDensity,
//     this.constraints,
//     this.debounceKey,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Create a unique key for debouncing
//     final key = debounceKey ??
//         'debounced_icon_button_${this.key?.hashCode ?? hashCode}_${icon.hashCode}';
//
//     void Function()? debouncedOnPressed;
//     if (onPressed != null) {
//       debouncedOnPressed = () => DebounceUtil.execute(key, onPressed!);
//     }
//
//     return IconButton(
//       onPressed: debouncedOnPressed,
//       icon: icon,
//       tooltip: tooltip,
//       color: color,
//       focusColor: focusColor,
//       hoverColor: hoverColor,
//       highlightColor: highlightColor,
//       splashColor: splashColor,
//       disabledColor: disabledColor,
//       iconSize: iconSize,
//       padding: padding,
//       alignment: alignment,
//       semanticLabel: semanticLabel,
//       autofocus: autofocus,
//       splashRadius: splashRadius,
//       mouseCursor: mouseCursor,
//       focusNode: focusNode,
//       enableFeedback: enableFeedback,
//       style: style,
//       isSelected: isSelected,
//       selectedIcon: selectedIcon,
//       visualDensity: visualDensity,
//       constraints: constraints,
//     );
//   }
// }













