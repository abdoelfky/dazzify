import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';

class BranchesBottomSheetItem extends StatelessWidget {
  final String branchName;
  final void Function()? onTap;

  const BranchesBottomSheetItem({
    super.key,
    required this.branchName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        SolarIconsOutline.mapPoint,
        size: 24.r,
      ),
      title: DText(branchName),
      trailing: Icon(
        context.read<SettingsCubit>().state.currentLanguageCode ==
                AppConstants.enCode
            ? SolarIconsOutline.altArrowRight
            : SolarIconsOutline.altArrowLeft,
        size: 24.0.r,
      ),
    );
  }
}
