import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class ServiceOrPhotoMessage extends StatelessWidget {
  final MessageModel message;

  const ServiceOrPhotoMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender == Sender.user.name
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ).r,
        child: Column(
          crossAxisAlignment: message.sender == Sender.user.name
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              width: 230.w,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ).r,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230.w,
                      height: 200.h,
                      child: GestureDetector(
                        onTap: () {
                          if (message.messageType == MessageType.photo.name) {
                            context.pushRoute(DazzifyPhotoViewerRoute(
                              name:
                                  TimeManager.dateTimeOrTime(message.createdAt),
                              imageUrl: message.content.image!,
                              heroAnimationKey: AssetsManager.avatar,
                              isProfilePicture: true,
                            ));
                          }
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ).r,
                          child: DazzifyCachedNetworkImage(
                            imageUrl: message.content.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    if (message.messageType == MessageType.service.name)
                      DText(
                        message.content.message!,
                        style: context.textTheme.titleSmall,
                      )
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            DText(
              TimeManager.to12HFormat(TimeManager.toLocal(message.createdAt)),
              style: context.textTheme.labelSmall!.copyWith(
                color: context.colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
