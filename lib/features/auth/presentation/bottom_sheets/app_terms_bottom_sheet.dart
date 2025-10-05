import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/auth/logic/auth_cubit.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class AppTermsBottomSheet extends StatefulWidget {
  final void Function(bool hasAgreed) onAgreeTap;

  const AppTermsBottomSheet({super.key, required this.onAgreeTap});

  @override
  State<AppTermsBottomSheet> createState() => _AppTermsBottomSheetState();
}

class _AppTermsBottomSheetState extends State<AppTermsBottomSheet> {
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
    context.read<AuthCubit>().getAppTerms();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _hasReachedTheEnd = ValueNotifier(false);
    _hasCheckedAgree = ValueNotifier(false);

    // ✅ إذا لا يوجد scroll، اعتبر أنه وصل للنهاية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent == 0) {
        _hasReachedTheEnd.value = true;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    _hasReachedTheEnd.dispose();
    _hasCheckedAgree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.termsSheetTitle,
      titleBottomPadding: 8.h,
      textStyle: context.textTheme.bodyLarge,
      height: AppConstants.bottomSheetHeight,
      handlerHeight: 4.h,
      handlerWidth: 120.w,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: SizedBox(
            height: 280.h,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AppTermsLoadingState) {
                  return LoadingAnimation(
                    height: 70.h,
                    width: 70.w,
                  );
                } else if (state is AppTermsSuccessState) {
                  return Scrollbar(
                    radius: const Radius.circular(20).r,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      itemCount: state.appTerms.length,
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
                                padding: const EdgeInsets.only(top: 4.0).r,
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
                                  state.appTerms[index],
                                  softWrap: true,
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
        Spacer(),
        Column(
          
          children: [
            ValueListenableBuilder(
              valueListenable: _hasReachedTheEnd,
              builder: (_, reachedEnd, __) {
                if (!reachedEnd) return const SizedBox.shrink();

                return ValueListenableBuilder(
                  valueListenable: _hasCheckedAgree,
                  builder: (_, checked, __) {
                    return Row(
                      children: [
                        Checkbox(
                          value: checked,
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
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w, left: 5.w),
                      child: PrimaryButton(
                        height: 42.h,
                        onTap: () {
                          context.maybePop();
                        },
                        title: context.tr.cancel,
                        textColor: context.colorScheme.primary,
                        isOutLined: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w, left: 5.w),
                      child: ValueListenableBuilder(
                        valueListenable: _hasReachedTheEnd,
                        builder: (_, reachedEnd, __) {
                          return ValueListenableBuilder(
                            valueListenable: _hasCheckedAgree,
                            builder: (_, checked, __) {
                              final isActive = reachedEnd && checked;
                              return PrimaryButton(
                                isActive: isActive,
                                title: context.tr.agree,
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
