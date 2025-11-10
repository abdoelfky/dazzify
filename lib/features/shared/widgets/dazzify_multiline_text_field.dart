import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:mwidgets/mwidgets.dart';

class DazzifyMultilineTextField extends StatelessWidget {
  final double? fullWidth;
  final double? fullHeight;
  final double? fieldHeight;
  final double? fieldWidth;
  final String hintText;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final void Function(String? value)? onChanged;
  final int? maxLength;

  const DazzifyMultilineTextField({
    super.key,
    this.fullWidth,
    this.fullHeight,
    this.fieldHeight,
    this.fieldWidth,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.controller,
    this.autoValidateMode,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
      builder: (state) {
        return SizedBox(
          width: fullWidth ?? context.width,
          height: fullHeight ?? context.height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: fieldHeight ?? 160,
                width: fieldWidth,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: maxLength,
                  autofocus: false,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.r,
                    // color: Theme.of(context).colorScheme.scrim,
                  ),
                  onChanged: (value) {
                    state.didChange(value);
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.r,
                      // color: Theme.of(context).colorScheme.scrim,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              if (state.errorText != null)
                CustomFadeAnimation(
                  duration: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DText(
                      state.errorText!,
                      style: TextStyle(
                        color: context.colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
