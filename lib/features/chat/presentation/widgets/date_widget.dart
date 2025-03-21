import 'package:dazzify/core/framework/export.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({required this.date, super.key});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: DText(
        date,
        textAlign: TextAlign.center,
        style: context.textTheme.bodySmall!
            .copyWith(color: context.colorScheme.primaryContainer),
      ),
    );
  }
}
