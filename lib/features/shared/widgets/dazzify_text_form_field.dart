import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class DazzifyTextFormField extends StatefulWidget {
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool? obscureText;
  final int? maxLength;
  final String? label;
  final Function(String submittedText)? onSubmit;
  final Function(String? value)? onSaved;
  final VoidCallback? onSuffixPress;
  final String? hintText;
  final double? borderRadius;
  final Color? enableBorderColor;
  final FormFieldValidator? validator;
  final double? textFieldHeight;
  final BoxConstraints? boxConstraints;
  final bool? isFieldValid;
  final void Function(String value)? onChanged;
  final Widget? suffixIcon;
  final bool readOnly;
  final BorderSide? borderSide;
  final Color? fillColor;
  final bool expands;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final AutovalidateMode? autoValidationMode;
  final bool enableCounter;

  const DazzifyTextFormField({
    super.key,
    this.width,
    this.height,
    this.controller,
    required this.textInputType,
    this.textInputAction,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.label,
    this.onSuffixPress,
    this.hintText,
    this.onSubmit,
    this.borderRadius,
    this.enableBorderColor,
    this.onSaved,
    this.validator,
    this.textFieldHeight,
    this.boxConstraints,
    this.maxLength,
    this.isFieldValid,
    this.onChanged,
    this.suffixIcon,
    this.borderSide,
    this.fillColor,
    this.readOnly = false,
    this.expands = false,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.onTap,
    this.contentPadding,
    this.textStyle,
    this.autoValidationMode,
    this.enableCounter = false,
  });

  @override
  State<DazzifyTextFormField> createState() => _DazzifyTextFormFieldState();
}

class _DazzifyTextFormFieldState extends State<DazzifyTextFormField> {
  final ValueNotifier<bool?> _obscuredText = ValueNotifier(null);

  @override
  void initState() {
    if (widget.obscureText == true) {
      _obscuredText.value = widget.obscureText!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4).r,
      child: ValueListenableBuilder(
        valueListenable: _obscuredText,
        builder: (context, value, child) => SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextFormField(
            focusNode: widget.focusNode,
            autofocus: false,
            buildCounter: widget.enableCounter
                ? null
                : (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) =>
                    null,
            scrollPadding: const EdgeInsets.only(bottom: 300).r,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            autovalidateMode:
                widget.autoValidationMode ?? AutovalidateMode.onUserInteraction,
            obscureText: value ?? false,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            onSaved: widget.onSaved,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            maxLength: widget.maxLength,
            onFieldSubmitted: widget.onSubmit,
            expands: widget.expands,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            style: widget.textStyle ??
                context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
            decoration: InputDecoration(
              errorStyle: context.textTheme.labelSmall!.copyWith(
                height: 0.3.h,
                color: Colors.red,
              ),
              filled: widget.fillColor == null ? false : true,
              fillColor: widget.fillColor,
              constraints: widget.boxConstraints,
              hintText: widget.hintText,
              errorMaxLines: 1,
              prefixIcon: widget.prefixIconData == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0).r,
                      child: Icon(
                        widget.prefixIconData!,
                        size: 20.r,
                      ),
                    ),
              suffixIcon: widget.suffixIcon ??
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                    child: _buildSuffix(),
                  ),
              labelText: widget.label,
              labelStyle: context.textTheme.bodySmall!.copyWith(
                color: _buildLabelColor(),
              ),
              contentPadding:
                  widget.contentPadding ?? const EdgeInsets.all(15.0).r,
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 8.0).r,
                borderSide: widget.borderSide ??
                    BorderSide(
                      color: widget.isFieldValid != null &&
                              widget.isFieldValid! &&
                              widget.controller!.text.isNotEmpty
                          ? Colors.green
                          : widget.enableBorderColor ??
                              context.colorScheme.outline,
                    ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 8.0).r,
                borderSide: widget.borderSide ??
                    BorderSide(
                      color: widget.isFieldValid != null &&
                              widget.isFieldValid! &&
                              widget.controller!.text.isNotEmpty
                          ? Colors.green
                          : context.colorScheme.primary,
                    ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 8.0).r,
                borderSide: widget.borderSide ??
                    BorderSide(color: context.colorScheme.error),
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 8.0).r,
                borderSide: widget.borderSide ??
                    BorderSide(
                      color: widget.enableBorderColor ??
                          context.colorScheme.outline,
                    ),
              ),
            ),
            validator: widget.validator ??
                ValidationManager.basicValidator(
                  context: context,
                  label: widget.label,
                ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffix() {
    if (_obscuredText.value != null && widget.isFieldValid == null) {
      return ValueListenableBuilder(
        valueListenable: _obscuredText,
        builder: (context, value, child) => IconButton(
          onPressed: () {
            if (value != null) {
              _obscuredText.value = !value;
            }
            widget.onSuffixPress;
          },
          icon: Icon(_buildObscureSuffixIcon(), size: 22.sp),
        ),
      );
    } else if (widget.isFieldValid != null) {
      return _buildValidationIcon();
    } else if (widget.suffixIconData != null) {
      return Icon(widget.suffixIconData!);
    } else {
      return null;
    }
  }

  IconData _buildObscureSuffixIcon() {
    if (_obscuredText.value == true) {
      return SolarIconsOutline.eye;
    } else {
      return SolarIconsOutline.eyeClosed;
    }
  }

  Icon _buildValidationIcon() {
    if (widget.isFieldValid == false && widget.controller!.text.isEmpty ||
        widget.controller!.text.isEmpty) {
      return Icon(
        SolarIconsOutline.checkCircle,
        color: Colors.transparent,
        size: 22.r,
      );
    } else if (widget.isFieldValid == true) {
      return Icon(
        SolarIconsOutline.checkCircle,
        color: Colors.green,
        size: 22.r,
      );
    } else {
      return Icon(
        SolarIconsOutline.dangerCircle,
        color: Colors.red,
        size: 22.r,
      );
    }
  }

  Color _buildLabelColor() {
    if (widget.isFieldValid != null && widget.controller!.text.isNotEmpty) {
      if (widget.isFieldValid!) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      return context.colorScheme.outline;
    }
  }

  @override
  void dispose() {
    _obscuredText.dispose();
    super.dispose();
  }
}
