import 'dart:math' as math;

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/widgets/swipe_button/dazzify_swipe_button_controller.dart';
import 'package:lottie/lottie.dart';

class DazzifySwipeButton extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? swipedBackgroundColor;
  final String title;
  final String swipedTitle;

  final DazzifySwipeButtonController dazzifySwipeButtonController;
  final void Function() onSwipe;

  const DazzifySwipeButton({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.swipedBackgroundColor,
    required this.onSwipe,
    required this.title,
    required this.swipedTitle,
    required this.dazzifySwipeButtonController,
  });

  @override
  State<DazzifySwipeButton> createState() => _DazzifySwipeButtonState();
}

class _DazzifySwipeButtonState extends State<DazzifySwipeButton> {
  late final DazzifySwipeButtonController _controller;
  bool _showSlideText = false;
  late Offset _dragStart;

  @override
  void initState() {
    _controller = widget.dazzifySwipeButtonController
      ..addListener(_slideListener);
    super.initState();
  }

  void _slideListener() {
    setState(() {
      _showSlideText = _controller.value > 0;
    });
    if (_controller.markAsExecuted()) {
      // Only execute if not previously executed
      widget.onSwipe();
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_controller.value >= 1) return;
    final dx = details.globalPosition.dx - _dragStart.dx;
    double slidePercent =
        dx / (widget.width ?? context.screenWidth * 0.95 - 13.w);
    slidePercent = slidePercent.clamp(0.0, 1.0);
    _controller.value = slidePercent;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.value >= 1) {
      // Keep at completed state
    } else {
      // Reset both value and execution state
      _controller.resetSwipeState();
    }
  }

  @override
  Widget build(BuildContext context) => _buildSwipeButton();

  Widget _buildSwipeButton() {
    return Stack(
      children: [
        Container(
          width: widget.width ?? context.screenWidth * 0.95,
          height: widget.height ?? 52.h,
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Transform.rotate(
              angle: (90 * math.pi) / 180,
              child: LottieBuilder.asset(
                AssetsManager.arrowAnimation,
                width: 150.w,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          left: _controller.value > 0 ? context.screenWidth : 130.w,
          top: 0,
          bottom: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Center(
            child: DText(
              widget.title,
              style: TextStyle(
                color: context.colorScheme.onSurface,
                fontSize: 14.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragDown: (details) {
            _dragStart = details.globalPosition;
          },
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: _buildSwipedContainer(),
        ),
      ],
    );
  }

  Widget _buildSwipedContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: widget.height ?? 52.h,
      width: _controller.value > 0
          ? widget.width ?? context.screenWidth * 0.95
          : 43.w,
      decoration: BoxDecoration(
        color: widget.swipedBackgroundColor ?? context.colorScheme.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _showSlideText
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: DText(
                  widget.swipedTitle,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              )
            : Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 18.r,
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_slideListener);
    super.dispose();
  }
}
