import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/settings/logic/privacy_policy_cubit.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatefulWidget implements AutoRouteWrapper {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PrivacyPolicyCubit>()..getPrivacyPolicies(),
      child: this,
    );
  }

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DText(
          context.tr.privacyPolicy,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            context.currentTextDirection == TextDirection.ltr
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
          ),
          onPressed: () => context.maybePop(),
        ),
      ),
      body: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
        builder: (context, state) {
          if (state.loadingState == UiState.loading) {
            return Center(
              child: LoadingAnimation(
                height: 70.h,
                width: 70.w,
              ),
            );
          } else if (state.loadingState == UiState.failure) {
            return ErrorDataWidget(
              onRetry: () {
                context.read<PrivacyPolicyCubit>().getPrivacyPolicies();
              },
            );
          } else if (state.loadingState == UiState.success) {
            if (state.policies.isEmpty) {
              return Center(
                child: DText(
                  context.tr.noPrivacyPoliciesAvailable,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: state.policies.length,
              itemBuilder: (context, index) {
                final policy = state.policies[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DText(
                          policy.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        DText(
                          policy.content,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
