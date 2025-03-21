import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';

class NotificationsItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationsItem({
    required this.notification,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: context.screenWidth,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(12)).r,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DText(
                  notification.title,
                  style: context.textTheme.titleMedium,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DText(
                        notification.body,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0).r,
          child: DText(
            TimeManager.dateTimeOrTime(notification.date),
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
