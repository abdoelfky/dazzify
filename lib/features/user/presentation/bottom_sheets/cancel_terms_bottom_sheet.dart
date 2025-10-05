import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class CancelTermsBottomSheet extends StatefulWidget {
  final void Function(bool hasAgreed) onAgreeTap;
  final List<String> refundConditions;

  const CancelTermsBottomSheet({
    super.key,
    required this.onAgreeTap,
    required this.refundConditions,
  });

  @override
  State<CancelTermsBottomSheet> createState() => _CancelTermsBottomSheetState();
}

class _CancelTermsBottomSheetState extends State<CancelTermsBottomSheet> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _hasReachedTheEnd;
  late final ValueNotifier<bool> _hasCheckedAgree;

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      _hasReachedTheEnd.value = true;
    }
  }


  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _hasReachedTheEnd = ValueNotifier(false);
    _hasCheckedAgree = ValueNotifier(false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ If no scroll is needed, activate hasReachedTheEnd
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent == 0) {
        _hasReachedTheEnd.value = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.cancelTermsSheetTitle,
      height: 480.h,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: SizedBox(
            height: widget.refundConditions.isEmpty ? 70.h : 280.h,
            child: widget.refundConditions.isEmpty
                ? LoadingAnimation(
                    height: 70.h,
                    width: 70.w,
                  )
                : Scrollbar(
                    radius: const Radius.circular(20).r,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      itemCount: widget.refundConditions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            left: 16.0,
                            right: 16.0,
                          ).r,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  // left: 16.0,
                                  // right: 16.0,
                                ).r,
                                child: Container(
                                  width: 8.r,
                                  height: 8.r,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.onSurface,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: DText(
                                  widget.refundConditions[index],
                                  softWrap: true,
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10).r,
          child: Column(
            children: [
              if (widget.refundConditions.isNotEmpty)
                ValueListenableBuilder(
                  valueListenable: _hasReachedTheEnd,
                  builder: (_, hasReached, __) {
                    if (!hasReached) return const SizedBox.shrink();

                    return ValueListenableBuilder(
                      valueListenable: _hasCheckedAgree,
                      builder: (_, hasChecked, __) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8).r,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: hasChecked,
                                onChanged: (val) =>
                                _hasCheckedAgree.value = val ?? false,
                              ),
                              Expanded(
                                child: DText(
                                  context.tr.iAgreeToTerms,
                                  style: context.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    width: 155.w,
                    height: 42.h,
                    onTap: () {
                      context.maybePop();
                    },
                    title: context.tr.cancel,
                    textColor: context.colorScheme.primary,
                    isOutLined: true,
                  ),

                  ValueListenableBuilder(
                    valueListenable: _hasReachedTheEnd,
                    builder: (context, hasReached, child) {
                      return ValueListenableBuilder(
                        valueListenable: _hasCheckedAgree,
                        builder: (context, hasChecked, child) {
                          bool isScrollable =
                              widget.refundConditions.length > 10;
                          bool isAgreeActive = isScrollable
                              ? (hasReached && hasChecked)
                              : hasChecked;

                          return PrimaryButton(
                            isActive: isAgreeActive,
                            title: context.tr.agree,
                            width: 155.w,
                            height: 42.h,
                            onTap: () {
                              widget.onAgreeTap(true);
                              context.maybePop();
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Ensure "Agree" button is always enabled if the list is short or when the user has scrolled to the end.
                  // ValueListenableBuilder(
                  //   valueListenable: _hasReachedTheEnd,
                  //   builder: (context, value, child) {
                  //     bool isAgreeActive = widget.refundConditions.length > 10
                  //         ? value
                  //         : true; // Make agree button active if no scroll is needed
                  //     return PrimaryButton(
                  //       isActive: isAgreeActive,
                  //       title: context.tr.agree,
                  //       width: 155.w,
                  //       height: 42.h,
                  //       onTap: () {
                  //         widget.onAgreeTap(true);
                  //         context.maybePop();
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController
      ..dispose()
      ..removeListener(_scrollListener);
    _hasReachedTheEnd.dispose();
    _hasCheckedAgree.dispose();

    super.dispose();
  }
}
