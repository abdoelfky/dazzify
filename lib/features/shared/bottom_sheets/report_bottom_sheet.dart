import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/shared/logic/report/report_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_multiline_text_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwidgets/mwidgets.dart';

class ReportBottomSheet extends StatelessWidget {
  const ReportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReportCubit>();

    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state.uiState == UiState.success) {
          FocusManager.instance.primaryFocus?.unfocus();
          DazzifyToastBar.showSuccess(message: context.tr.reported);
          context.pop();
        }
        if (state.uiState == UiState.failure) {
          DazzifyToastBar.showError(message: state.message);
        }
      },
      builder: (context, state) {
        return DazzifyOverlayLoading(
          isLoading: state.uiState == UiState.loading,
          child: Form(
            key: cubit.formKey,
            child: DazzifySheetBody(
              title: context.tr.report,
              titleBottomPadding: 8.r,
              textStyle: Theme.of(context).textTheme.bodyLarge,
              height:
                  context.isKeyboardClosed ? 350.h : context.screenHeight * 0.8,
              handlerHeight: 4.h,
              handlerWidth: 120.w,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ).r,
                  child: DazzifyMultilineTextField(
                    controller: cubit.reportController,
                    maxLength: 300,
                    hintText: DazzifyApp.tr.reportYourIssue,
                    validator: (value) {
                      return ValidationManager.hasData(
                        data: cubit.reportController.text,
                        errorMessage: context.tr.textIsTooShort,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: PrimaryButton(
                    onTap: () {
                      cubit.execute();
                    },
                    title: context.tr.report,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

showReportBottomSheet({
  required BuildContext context,
  required String id,
  required String type,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(
      name: "ٌReportBottomSheet",
    ),
    builder: (context) => BlocProvider(
      create: (context) => getIt<ReportCubit>()..setUp(type, id),
      child: ReportBottomSheet(),
    ),
  );
}
