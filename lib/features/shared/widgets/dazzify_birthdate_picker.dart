import 'package:flutter/material.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class DazzifyBirthdatePicker extends StatefulWidget {
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

  const DazzifyBirthdatePicker({
    super.key,
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
  State<DazzifyBirthdatePicker> createState() => _DazzifyBirthdatePickerState();
}

class _DazzifyBirthdatePickerState extends State<DazzifyBirthdatePicker> {
  TextEditingController _controller = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        _controller.text = '${picked.day}/${picked.month}/${picked.year}';
      });
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: _controller,
      readOnly: true,
      // Make it read-only so the user can't type manually
      onTap: () => _selectDate(context),
      // Show date picker on tap
      decoration: InputDecoration(

          hintText: widget.hintText,
          errorStyle: context.textTheme.bodySmall!.copyWith(
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
          suffixIcon: Icon(
            SolarIconsOutline.altArrowDown,
            size: 20.sp,
          )
          // Icon(
          //   Icons.arrow_drop_down, // Dropdown arrow
          //   size: 24.r,  // Adjust size if needed
          //   color: context.colorScheme.onSurface,  // Change color if necessary
          // ),
          ),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
