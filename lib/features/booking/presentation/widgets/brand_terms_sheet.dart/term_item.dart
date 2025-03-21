import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/presentation/widgets/brand_terms_sheet.dart/term_checkbox.dart';

class TermItem extends StatelessWidget {
  final void Function() onBoxTap;
  final String term;
  final bool isChecked;

  const TermItem({
    required this.onBoxTap,
    required this.term,
    required this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBoxTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24).r,
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.onSurface,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: DText(term),
            ),
            SizedBox(
              width: 8.w,
            ),
            SizedBox(
              width: 16.w,
              height: 16.h,
              child: TermCheckBox(
                onBoxTap: onBoxTap,
                isChecked: isChecked,
              ),
            )
          ],
        ),
      ),
    );
  }
}
