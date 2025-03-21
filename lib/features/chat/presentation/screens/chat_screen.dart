import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/chat/logic/chat_cubit.dart';
import 'package:dazzify/features/chat/logic/conversations_cubit.dart';
import 'package:dazzify/features/chat/presentation/widgets/date_widget.dart';
import 'package:dazzify/features/chat/presentation/widgets/service_or_photo_message.dart';
import 'package:dazzify/features/chat/presentation/widgets/text_message.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';

@RoutePage()
class ChatScreen extends StatefulWidget implements AutoRouteWrapper {
  final BrandModel brand;
  final String branchId;
  final String branchName;
  final String? serviceToBeSent;

  const ChatScreen({
    required this.brand,
    required this.branchId,
    required this.branchName,
    this.serviceToBeSent,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => getIt<ChatCubit>()
        ..setUp(branchId: branchId, branchName: branchName, brand: brand)
        ..getAllMessages(),
      child: this,
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController textController;
  late final ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.conversationsCubit = context.read<ConversationsCubit>();
    textController = TextEditingController();

    if (widget.serviceToBeSent != null) {
      _chatCubit.sendMessage(
        messageType: MessageType.service.name,
        serviceId: widget.serviceToBeSent,
        onMessageSent: (message) {
          _chatCubit.conversationsCubit.addConversationIfNotExist(
            brand: widget.brand,
            branchId: widget.branchId,
            branchName: widget.branchName,
            lastMessage: message,
          );
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ).r,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.maybePop();
                    },
                    icon: Icon(
                      context.currentTextDirection == TextDirection.ltr
                          ? SolarIconsOutline.arrowLeft
                          : SolarIconsOutline.arrowRight,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(DazzifyPhotoViewerRoute(
                        name: widget.brand.name,
                        imageUrl: widget.brand.logo,
                        heroAnimationKey: AssetsManager.avatar,
                        isProfilePicture: true,
                      ));
                    },
                    child: CircleAvatar(
                      radius: 20.r,
                      foregroundImage: DazzifyCachedNetworkImageProvider(
                        widget.brand.logo,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.navigateTo(BrandProfileRoute(
                          brand: widget.brand,
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DText(
                                widget.brand.name,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.brand.verified)
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 8.0.r),
                                  child: Icon(
                                    SolarIconsBold.verifiedCheck,
                                    color: context.colorScheme.primary,
                                    size: 15.r,
                                  ),
                                )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                SolarIconsOutline.map,
                                size: 16.r,
                                color: context.colorScheme.primary,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                child: DText(
                                  widget.branchName,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: context.screenWidth,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30).r,
                      topRight: const Radius.circular(30).r),
                ),
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    switch (state.fetchingMessagesState) {
                      case UiState.initial:
                      case UiState.loading:
                        return const DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.messages,
                        );
                      case UiState.failure:
                        return ErrorDataWidget(
                          errorDataType: DazzifyErrorDataType.screen,
                          message: state.errorMessage,
                          onTap: () {
                            _chatCubit.getAllMessages();
                          },
                        );
                      case UiState.success:
                        if (state.messages.isEmpty) {
                          return Center(
                            child: EmptyDataWidget(
                              message: DazzifyApp.tr.noMessages,
                            ),
                          );
                        } else {
                          return CustomFadeAnimation(
                            duration: const Duration(milliseconds: 700),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 16).r,
                              itemCount: state.messages.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                if (state.messages[index].runtimeType ==
                                    String) {
                                  return DateWidget(
                                    date: state.messages[index].messageSentTime,
                                  );
                                } else {
                                  if (state.messages[index].messageType !=
                                      MessageType.txt.name) {
                                    return ServiceOrPhotoMessage(
                                      message: state.messages[index],
                                    );
                                  } else {
                                    return TextMessage(
                                      message: state.messages[index],
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
            ),
            Container(
              color: context.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Row(
                  children: [
                    Expanded(
                      child: DazzifyTextFormField(
                        maxLength: 1000,
                        hintText: "${context.tr.message}..",
                        controller: textController,
                        validator: (text) => null,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16).r,
                        minLines: 1,
                        maxLines: 6,
                        textInputType: TextInputType.text,
                        borderRadius: 10.r,
                        fillColor: context.colorScheme.primaryFixed,
                        borderSide: BorderSide.none,
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            _chatCubit.sendMessage(
                              messageType: MessageType.photo.name,
                            );
                          },
                          icon: Icon(
                            SolarIconsOutline.camera,
                            color: context.colorScheme.primary,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: context.colorScheme.primary,
                      child: IconButton(
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            _chatCubit.sendMessage(
                              messageType: MessageType.txt.name,
                              text: textController.text,
                            );

                            textController.clear();
                          }
                        },
                        icon: Icon(
                          SolarIconsBold.plain,
                          color: context.colorScheme.onPrimary,
                          size: 22.r,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
