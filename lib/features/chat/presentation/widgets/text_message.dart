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
    final isPending = message.sendStatus == 'pending' || message.sendStatus == 'uploading';
    final isFailed = message.sendStatus == 'failed';
    
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
                    ? context.colorScheme.primary.withValues(alpha: isPending ? 0.6 : 1.0)
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        message.content.message!,
                        style: context.textTheme.titleSmall!.copyWith(
                          color: message.sender == Sender.user.name
                              ? context.colorScheme.onPrimary
                              : context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isPending && message.sender == Sender.user.name) ...[
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 12.w,
                        height: 12.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isFailed && message.sender == Sender.user.name) ...[
                  Icon(
                    Icons.error_outline,
                    size: 14.sp,
                    color: Colors.red,
                  ),
                  SizedBox(width: 4.w),
                ],
                Text(
                  isFailed 
                      ? 'Failed to send'
                      : TimeManager.to12HFormat(TimeManager.toLocal(message.createdAt)),
                  style: context.textTheme.labelSmall!.copyWith(
                    color: isFailed 
                        ? Colors.red 
                        : context.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
