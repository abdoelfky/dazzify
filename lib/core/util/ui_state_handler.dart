import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UiStateHandler<T> extends StatelessWidget {
  final UiState state;
  final T data;
  final T skeletonData;
  final String errorMessage, emptyMessage;
  final VoidCallback? onRetry;
  final String? emptyIconPath;
  final UILoadingType loadingType;
  final Widget Function(T data) builder;
  final double? emptyIconWidth,
      emptyIconHeight,
      contentLoadingWidth,
      contentLoadingHeight;

  // Skeletonizer configurations
  final bool enabled, ignoreContainers, ignorePointers, showOverlayLoading;
  final PaintingEffect? effect;
  final TextStyle? textStyle;

  // Custom configurations
  final Widget? emptyWidget;
  final Widget? errorWidget;

  // CallBacks
  final Function()? onSuccess;
  final Function()? onFailure;

  const UiStateHandler({
    super.key,
    required this.state,
    required this.builder,
    required this.data,
    required this.skeletonData,
    this.showOverlayLoading = false,
    this.errorMessage = "",
    this.onRetry,
    this.emptyMessage = "",
    this.emptyIconPath,
    this.loadingType = UILoadingType.skeleton,
    this.emptyIconWidth = 120,
    this.emptyIconHeight = 120,
    this.contentLoadingWidth,
    this.contentLoadingHeight,
    this.enabled = true,
    this.effect,
    this.textStyle,
    this.ignoreContainers = false,
    this.ignorePointers = true,
    this.emptyWidget,
    this.errorWidget,
    this.onSuccess,
    this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UiState.initial:
      case UiState.loading:
        switch (loadingType) {
          case UILoadingType.skeleton:
            return Skeletonizer(
              enabled: true,
              effect: effect ?? const ShimmerEffect(),
              ignoreContainers: ignoreContainers,
              ignorePointers: ignorePointers,
              child: builder(skeletonData),
            );
          case UILoadingType.overlay:
            return DazzifyOverlayLoading(
              isLoading: true,
              child: builder(data),
            );
          case UILoadingType.content:
            return LoadingAnimation(
              height: contentLoadingHeight,
              width: contentLoadingWidth,
            );
        }
      case UiState.failure:
        if (onFailure != null) onFailure!();
        return errorWidget ??
            ErrorDataWidget(
              errorDataType: DazzifyErrorDataType.screen,
              message: errorMessage,
              onTap: onRetry,
            );

      case UiState.success:
        if (onSuccess != null) onSuccess!();
        if (data == null || (data is List && (data as List).isEmpty)) {
          return emptyWidget ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: EmptyDataWidget(
                  svgIconPath: emptyIconPath,
                  message: emptyMessage,
                  width: emptyIconWidth!,
                  height: emptyIconHeight!,
                ),
              );
        }
        return DazzifyOverlayLoading(
          isLoading: showOverlayLoading,
          child: builder(data),
        );
    }
  }
}
