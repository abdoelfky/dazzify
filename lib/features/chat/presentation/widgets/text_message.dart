import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/time_manager.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextMessage extends StatelessWidget {
  final MessageModel message;

  const TextMessage({
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
              decoration: BoxDecoration(
                color: message.sender == Sender.user.name
                    ? context.colorScheme.primary
                    : context.colorScheme.inversePrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(40).r,
                    topEnd: const Radius.circular(40).r,
                    bottomEnd: message.sender == Sender.user.name
                        ? Radius.zero
                        : const Radius.circular(40).r,
                    bottomStart: message.sender == Sender.user.name
                        ? Radius.circular(40.r)
                        : Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Text(
                  message.content.message!,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: message.sender == Sender.user.name
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
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
