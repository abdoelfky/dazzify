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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.termsSheetTitle,
      height: 480.h,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8.r,
                                  height: 8.r,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.onSurface,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Flexible(
                                  child: DText(
                                    state.appTerms[index],
                                    softWrap: true,
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
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
                    return Container();
                  }
                },
              )),
        ),
        SizedBox(height: 8.h),
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
              builder: (context, value, child) => PrimaryButton(
                isActive: value,
                title: context.tr.agree,
                width: 155.w,
                height: 42.h,
                onTap: () {
                  widget.onAgreeTap(true);
                  context.maybePop();
                },
              ),
            ),
          ],
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
    super.dispose();
  }
}
