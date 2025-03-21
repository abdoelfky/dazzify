import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/clock_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildVendorSessionsStack extends StatelessWidget {
  final double diameter;

  const BuildVendorSessionsStack({
    required this.diameter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceAvailabilityCubit, ServiceAvailabilityState>(
      builder: (context, state) {
        List<VendorSessionModel> selectedDaySessions =
            state.availableSessions[state.selectedDayTime]!;

        List<Widget> sessionsStack = getSessionsStack(
          vendorSessions: selectedDaySessions,
          isAnySessionSelected: state.isAnySessionSelected,
          selectedSessionIndex: state.selectedSessionIndex,
          diameter: diameter,
          inActiveColor: context.colorScheme.tertiaryContainer,
        );

        return SizedBox(
          width: diameter,
          height: diameter,
          child: Stack(
            children: sessionsStack,
          ),
        );
      },
    );
  }
}

List<Widget> getSessionsStack({
  required List<VendorSessionModel> vendorSessions,
  required bool isAnySessionSelected,
  required int selectedSessionIndex,
  required double diameter,
  required Color inActiveColor,
}) {
  List<Widget> sessions = List.generate(vendorSessions.length, (index) {
    if (index != selectedSessionIndex) {
      return Center(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: CustomPaint(
            painter: ClockCustomPainer(
                fromTime: vendorSessions[index].fromTime,
                toTime: vendorSessions[index].toTime,
                activeBodyColor: ColorsManager.activeSessionBody,
                activeBorderColor: ColorsManager.activeSessionBorder,
                inActiveColor: inActiveColor,
                inActiveBorderColor: ColorsManager.inActiveSessionBorder,
                isSelected: false),
          ),
        ),
      );
    } else {
      return Container();
    }
  });

  if (sessions.isNotEmpty) {
    Widget activeSession = Center(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: CustomPaint(
          painter: ClockCustomPainer(
            fromTime: vendorSessions[selectedSessionIndex].fromTime,
            toTime: vendorSessions[selectedSessionIndex].toTime,
            activeBodyColor: ColorsManager.activeSessionBody,
            activeBorderColor: ColorsManager.activeSessionBorder,
            inActiveColor: inActiveColor,
            inActiveBorderColor: ColorsManager.inActiveSessionBorder,
            isSelected: true,
          ),
        ),
      ),
    );

    sessions.add(activeSession);
  }

  return sessions;
}
