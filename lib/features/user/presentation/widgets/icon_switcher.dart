import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconSwitcher extends StatelessWidget {
  final void Function(bool switched) onChanged;
  final IconData activeIcon;
  final Color activeIconColor;
  final IconData disabledIcon;
  final Color disabledIconColor;
  final bool switcherValue;
  final Color activeTrackColor;
  final Color activeThumbColor;
  final Color disabledTrackColor;
  final Color disabledThumbColor;
  final UiState? loadingState;

  const IconSwitcher({
    super.key,
    required this.onChanged,
    required this.activeIcon,
    required this.disabledIcon,
    required this.switcherValue,
    this.activeIconColor = ColorsManager.switcherActiveIconColor,
    this.activeTrackColor = ColorsManager.switcherActiveTrackColor,
    this.activeThumbColor = ColorsManager.switcherActiveThumbColor,
    this.disabledIconColor = ColorsManager.switcherDisabledIconColor,
    this.disabledTrackColor = ColorsManager.switcherDisabledTrackColor,
    this.disabledThumbColor = ColorsManager.switcherDisabledThumbColor,
    this.loadingState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 52.r,
          height: 32.r,
          child: Transform.scale(
            scale: 1.r,
            child: Switch(
              activeColor: activeThumbColor,
              activeTrackColor: activeTrackColor,
              inactiveTrackColor: disabledTrackColor,
              inactiveThumbColor: disabledThumbColor,
              onChanged: (value) {
                onChanged(value);
              },
              value: switcherValue,
            ),
          ),
        ),
        if (loadingState == UiState.loading)
          Positioned(
            left: switcherValue ? 28.r : 11.r,
            top: switcherValue ? 8.r : 10.r,
            child: CircleAvatar(
              radius: switcherValue ? 8.r : 5.r,
              backgroundColor: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(
                  color: context.colorScheme.inversePrimary,
                  strokeWidth: 2.0.r,
                ),
              ),
            ),
          ),
        PositionedDirectional(
          top: 0,
          bottom: 0,
          start: switcherValue ? 5.r : null,
          end: switcherValue ? null : 5.r,
          child: Icon(
            activeIcon,
            color: activeIconColor,
            size: 13.r,
          ),
        ),
        if (!switcherValue)
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 5.r,
            child: Icon(
              disabledIcon,
              color: disabledIconColor,
              size: 13.r,
            ),
          ),
      ],
    );
  }
}
