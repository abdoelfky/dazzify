import 'dart:ui';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class CommentOrReplyEditDialog extends StatefulWidget {
  final CommentsBloc commentsBloc;
  final String originalContent;
  final String commentId;
  final String? parentCommentId;
  final void Function(String) onEditTab;

  const CommentOrReplyEditDialog({
    required this.originalContent,
    required this.commentsBloc,
    required this.commentId,
    required this.onEditTab,
    this.parentCommentId,
    super.key,
  });

  @override
  State<CommentOrReplyEditDialog> createState() =>
      _CommentOrReplyEditDialogState();
}

class _CommentOrReplyEditDialogState extends State<CommentOrReplyEditDialog> {
  final TextEditingController editController = TextEditingController();

  @override
  void initState() {
    editController.text = widget.originalContent;
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 500),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ).r,
          child: Container(
            width: context.screenWidth * 0.9,
            height: 300.h,
            padding: const EdgeInsets.all(8).r,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16).r,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 221.h,
                  child: DText(
                    context.tr.editComment,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 36.h),
                DazzifyTextFormField(
                  textInputType: TextInputType.text,
                  controller: editController,
                  maxLines: 4,
                  maxLength: 200,
                  autoValidationMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (context.mounted) {
                              context.maybePop();
                            }
                          });
                        },
                        width: 145.w,
                        height: 42.h,
                        title: context.tr.cancel,
                        isOutLined: true,
                      ),
                      const Spacer(),
                      PrimaryButton(
                        onTap: () {
                          widget.onEditTab(editController.text);
                        },
                        width: 145.w,
                        height: 42.h,
                        title: context.tr.edit,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
