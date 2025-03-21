import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class ConversationCard extends StatelessWidget {
  final ConversationModel conversation;

  const ConversationCard({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.pushRoute(
          ChatRoute(
            brand: conversation.brand,
            branchId: conversation.branch.branchId,
            branchName: conversation.branch.branchName,
          ),
        );
      },
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).r,
          decoration: BoxDecoration(
            color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8).r,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                foregroundImage: DazzifyCachedNetworkImageProvider(
                  conversation.brand.logo,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              DText(
                                conversation.brand.name,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyLarge,
                              ),
                              if (conversation.brand.verified)
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 4.0.r),
                                  child: Icon(
                                    SolarIconsBold.verifiedCheck,
                                    color: context.colorScheme.primary,
                                    size: 15.r,
                                  ),
                                )
                            ],
                          ),
                        ),
                        DText(
                          TimeManager.dateOrTime(TimeManager.toLocal(
                              conversation.lastMessage.createdAt)),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
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
                            conversation.branch.branchName,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall!.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DText(
                      conversation.lastMessage.messageType ==
                              MessageType.txt.name
                          ? conversation.lastMessage.content.message!
                          : 'Sent ${conversation.lastMessage.messageType}',
                      style: context.textTheme.titleSmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
