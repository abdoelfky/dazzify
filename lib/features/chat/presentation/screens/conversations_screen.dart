import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/chat/logic/conversations_cubit.dart';
import 'package:dazzify/features/chat/presentation/components/conversation_component.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late final ConversationsCubit conversationsCubit;

  @override
  void initState() {
    super.initState();
    conversationsCubit = context.read<ConversationsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Handle back button if needed
      },
      child: SafeArea(
        child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await conversationsCubit.getConversations();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: DazzifyAppBar(
                  isLeading: false,
                  title: context.tr.chat,
                ),
              ),
              Expanded(
                child: BlocBuilder<ConversationsCubit, ConversationsState>(
                  builder: (context, state) {
                    switch (state.blocState) {
                      case UiState.initial:
                      case UiState.loading:
                        return DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.listView,
                          listViewItemCount: 6,
                          cardWidth: context.screenWidth,
                          cardHeight: 100.h,
                          widgetPadding: const EdgeInsets.only(
                            top: 24,
                            bottom: 90,
                            right: 16,
                            left: 16,
                          ).r,
                          borderRadius: BorderRadius.circular(12).r,
                        );
                      case UiState.failure:
                        return AuthLocalDatasourceImpl().checkGuestMode()
                            ? GuestModeWidget()
                            : ErrorDataWidget(
                                errorDataType: DazzifyErrorDataType.screen,
                                message: state.errorMessage,
                                onTap: () {
                                  conversationsCubit.getConversations();
                                },
                              );
                      case UiState.success:
                        if (state.conversations.isEmpty) {
                          return AuthLocalDatasourceImpl().checkGuestMode()
                              ? GuestModeWidget()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: EmptyDataWidget(
                                    svgIconPath:
                                        AssetsManager.chatRoundLineIcon,
                                    message: context.tr.noConversations,
                                    width: 120.w,
                                    height: 120.h,
                                  ),
                                );
                        } else {
                          return CustomFadeAnimation(
                            duration: const Duration(milliseconds: 500),
                            child: ListView.separated(
                              itemCount: state.conversations.length,
                              padding: const EdgeInsets.only(
                                top: 24,
                                bottom: 90,
                                right: 16,
                                left: 16,
                              ).r,
                              itemBuilder: (context, index) {
                                return ConversationCard(
                                  conversation: state.conversations[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      SizedBox(height: 16.h),
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
      ),
      ),
    );
  }
}
