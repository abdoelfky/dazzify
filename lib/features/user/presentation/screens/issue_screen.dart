import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/user/logic/issue/issue_bloc.dart';
import 'package:dazzify/features/user/presentation/widgets/issue_item.dart';

@RoutePage()
class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  late final IssueBloc issueBloc;
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    issueBloc = context.read<IssueBloc>();
    controller.addListener(_onScroll);
  }

  void _onScroll() async {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      issueBloc.add(const GetIssueEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.issue,
            ),
            Expanded(
              child: BlocBuilder<IssueBloc, IssueState>(
                builder: (context, state) {
                  switch (state.getIssueState) {
                    case UiState.initial:
                    case UiState.loading:
                      return const LoadingAnimation();
                    case UiState.failure:
                      return ErrorDataWidget(
                          errorDataType: DazzifyErrorDataType.screen,
                          message: state.errorMessage,
                          onTap: () {
                            issueBloc.add(const GetIssueEvent());
                          });
                    case UiState.success:
                      if (state.issueList.isEmpty) {
                        return Center(
                          child: EmptyDataWidget(
                            message: context.tr.noIssues,
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ).r,
                          child: RepaintBoundary(
                            child: ListView.separated(
                              controller: controller,
                              physics: const BouncingScrollPhysics(),
                              cacheExtent: 500.0,
                              itemCount: state.issueList.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Center(
                                  child: DText(
                                    context.tr.selectAndAddComment,
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      color: context.colorScheme.outline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              if (index - 1 >= state.issueList.length &&
                                  state.issueList.isNotEmpty) {
                                if (state.hasIssuesReachedMax) {
                                  return const SizedBox.shrink();
                                } else {
                                  return SizedBox(
                                    height: 70.h,
                                    width: context.screenWidth,
                                    child: LoadingAnimation(
                                      height: 50.h,
                                      width: 50.w,
                                    ),
                                  );
                                }
                              } else {
                                return RepaintBoundary(
                                  child: IssueItem(
                                    issue: state.issueList[index - 1],
                                  ),
                                );
                              }
                            },
                            separatorBuilder: (context, index) {
                              if (index != 0) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)
                                          .r,
                                  child: Divider(
                                    color: context.colorScheme.outlineVariant,
                                  ),
                                );
                              } else {
                                return SizedBox(height: 24.h);
                              }
                            },
                            ),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
