import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/time_manager.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceOrPhotoMessage extends StatelessWidget {
  final MessageModel message;

  const ServiceOrPhotoMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = message.sendStatus == 'pending' || message.sendStatus == 'uploading';
    final isUploading = message.sendStatus == 'uploading';
    final isFailed = message.sendStatus == 'failed';
    final uploadProgress = message.uploadProgress ?? 0.0;
    
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
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (message.messageType == MessageType.photo.name && 
                                  !isPending) {
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
                              child: isPending && message.localFilePath != null
                                  ? Image.file(
                                      File(message.localFilePath!),
                                      fit: BoxFit.cover,
                                      width: 230.w,
                                      height: 200.h,
                                    )
                                  : DazzifyCachedNetworkImage(
                                      imageUrl: message.content.image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          // Loading overlay for uploading images
                          if (isUploading)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ).r,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 50.w,
                                      height: 50.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                        value: uploadProgress > 0 ? uploadProgress : null,
                                      ),
                                    ),
                                    if (uploadProgress > 0) ...[
                                      SizedBox(height: 8.h),
                                      Text(
                                        '${(uploadProgress * 100).toInt()}%',
                                        style: context.textTheme.bodySmall!.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          // Failed overlay
                          if (isFailed)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ).r,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 50.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    if (message.messageType == MessageType.service.name)
                      Text(
                        message.content.message!,
                        style: context.textTheme.titleSmall,
                      )
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
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
                if (isUploading && message.sender == Sender.user.name) ...[
                  Icon(
                    Icons.upload,
                    size: 14.sp,
                    color: context.colorScheme.primaryContainer,
                  ),
                  SizedBox(width: 4.w),
                ],
                Text(
                  isFailed 
                      ? 'Failed to send'
                      : isUploading
                          ? 'Uploading...'
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
