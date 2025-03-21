import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/issue/issue_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IssueSheet extends StatefulWidget {
  final String bookingId;
  final String serviceTitle;

  const IssueSheet({
    super.key,
    required this.bookingId,
    required this.serviceTitle,
  });

  @override
  State<IssueSheet> createState() => _IssueSheetState();
}

class _IssueSheetState extends State<IssueSheet> {
  late final IssueBloc issueBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController issueMessageController = TextEditingController();

  @override
  void initState() {
    issueBloc = context.read<IssueBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).r,
      child: DazzifySheetBody(
        handlerWidth: 120,
        height: context.isKeyboardClosed
            ? context.screenHeight * 0.45
            : context.screenHeight * 0.85,
        title: "${widget.serviceTitle} ${context.tr.issue}",
        children: [
          SizedBox(height: 8.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DazzifyTextFormField(
                  controller: issueMessageController,
                  textInputType: TextInputType.text,
                  fillColor: context.colorScheme.surfaceContainerHighest,
                  borderSide: BorderSide.none,
                  borderRadius: 12,
                  height: 172.h,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  maxLength: 160,
                  hintText: context.tr.comment,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${context.tr.yourComment} ${context.tr.textIsRequired}";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                BlocConsumer<IssueBloc, IssueState>(
                  listener: (context, state) {
                    if (state.createIssueState == UiState.loading) {
                      isLoading = true;
                    } else if (state.createIssueState == UiState.success) {
                      context.maybePop();
                      DazzifyToastBar.showSuccess(
                        message: context.tr.issueCreated,
                      );
                      isLoading = false;
                    } else if (state.createIssueState == UiState.failure) {
                      DazzifyToastBar.showError(
                        message: state.errorMessage,
                      );
                      isLoading = false;
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      isLoading: isLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          issueBloc.add(
                            CreateIssueEvent(
                              bookingId: widget.bookingId,
                              comment: issueMessageController.text,
                            ),
                          );
                        }
                      },
                      title: context.tr.createIssue,
                      color: context.colorScheme.primary,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
