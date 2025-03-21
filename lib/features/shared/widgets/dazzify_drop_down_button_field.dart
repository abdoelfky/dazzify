import 'package:dazzify/core/framework/export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DazzifyDropDownButtonField extends StatefulWidget {
  final List<DropdownMenuItem> dropDownItems;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final String? label;
  final Function(String submittedText)? onSubmit;
  final Function(dynamic)? onSaved;
  final Function(dynamic)? onChanged;
  final String hintText;
  final double? borderRadius;
  final Color? enableBorderColor;
  final FormFieldValidator? validator;
  final void Function(bool isOpened)? onMenuOpen;

  const DazzifyDropDownButtonField({
    super.key,
    required this.dropDownItems,
    this.controller,
    this.prefixIcon,
    this.prefixIconData,
    this.label,
    this.onSubmit,
    this.onSaved,
    this.onChanged,
    required this.hintText,
    this.borderRadius,
    this.enableBorderColor,
    this.validator,
    this.onMenuOpen,
  });

  @override
  State<DazzifyDropDownButtonField> createState() =>
      _DazzifyDropDownButtonFieldState();
}

class _DazzifyDropDownButtonFieldState
    extends State<DazzifyDropDownButtonField> {
  ValueNotifier<bool> isMenuOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      autofocus: false,
      focusNode: FocusNode(canRequestFocus: false),
      hint: DText(
        widget.hintText,
        style: context.textTheme.bodyMedium,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      iconStyleData: const IconStyleData(iconEnabledColor: Colors.transparent),
      onMenuStateChange: (isOpen) {
        isMenuOpen.value = isOpen;
        if (widget.onMenuOpen != null) {
          widget.onMenuOpen!(isOpen);
        }
      },
      dropdownStyleData: DropdownStyleData(
        offset: const Offset(0, -7),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
      style: context.textTheme.bodyMedium,
      decoration: InputDecoration(
        errorStyle: context.textTheme.labelSmall!.copyWith(
          height: 0.3.h,
          color: Colors.red,
        ),
        hintStyle: context.textTheme.bodySmall,
        contentPadding: const EdgeInsets.all(15.0).r,
        errorMaxLines: 1,
        prefixIcon: widget.prefixIcon ??
            (widget.prefixIconData != null
                ? Icon(widget.prefixIconData, size: 20.r)
                : null),
        suffixIcon: ValueListenableBuilder(
          valueListenable: isMenuOpen,
          builder: (context, isMenuOpened, child) => AnimatedSwitcher(
            duration: const Duration(microseconds: 350),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: isMenuOpened
                ? Icon(
                    SolarIconsOutline.altArrowUp,
                    size: 20.r,
                  )
                : Icon(
                    SolarIconsOutline.altArrowDown,
                    size: 20.r,
                  ),
          ),
        ),
        labelText: widget.label,
        labelStyle: context.textTheme.bodySmall,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0).r,
          borderSide: BorderSide(
            color: widget.enableBorderColor ?? context.colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0).r,
          borderSide: BorderSide(
            color: context.colorScheme.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0).r,
          borderSide: BorderSide(
            color: context.colorScheme.error,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0).r,
          borderSide: BorderSide(
            color: widget.enableBorderColor ?? context.colorScheme.outline,
          ),
        ),
      ),
      items: widget.dropDownItems,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
