import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionConfirmation extends StatelessWidget {
  const SelectionConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceAvailabilityCubit, ServiceAvailabilityState>(
      builder: (context, state) {
        return CustomFadeAnimation(
          duration: const Duration(milliseconds: 750),
          child: SizedBox(
              width: 328.w,
              height: 36.h,
              child: InkWell(
                onTap: () {
                  context
                      .read<ServiceAvailabilityCubit>()
                      .changeSessionConfirmation(value: !state.isSessionConfirmed);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 250.w,
                      child: FittedBox(
                        child: DText(
                          context.tr.serviceSelectionConfirmation(
                            state.selectedSession.fromTime,
                            state.selectedSession.toTime,
                            state.selectedDate,
                          ),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: state.isSessionConfirmed,
                      onChanged: (value) {
                        context
                            .read<ServiceAvailabilityCubit>()
                            .changeSessionConfirmation(value: value!);
                      },
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
