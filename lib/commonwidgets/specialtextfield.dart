import 'package:flutter/material.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';

class SpecialTextfield extends StatelessWidget {
  final String? textfieldname;
  final String? innerHint;

  final TextInputType? textInputtype;
  final Widget? suffixwidget;
  final Function? onChanged;
  final TextCapitalization? textCapitalization;

  final Icon? prefixIcon;
  const SpecialTextfield({
    super.key,
    this.maxlines,
    this.onFieldSubmitted,
    this.onTap,
    this.initialValue,
    this.enabled,
    this.readonly,
    this.controller,
    this.ishidden,
    this.onChanged,
    this.suffixwidget,
    this.isMultiline,
    this.textCapitalization,
    this.textInputtype,
    this.textfieldname,
    this.enableSuggestion,
    this.innerHint,
    this.prefixIcon,
    this.border,
    this.contentPadding,
    this.validator,
  });
  final bool? ishidden;
  final bool? enabled;
  final String? Function(String?)? validator;
  final bool? enableSuggestion;
  final TextEditingController? controller;
  final int? maxlines;
  final InputBorder? border;
  final bool? isMultiline;
  final bool? readonly;
  final String? initialValue;
  final EdgeInsets? contentPadding;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      controller: controller,
      onTap: onTap,
      validator: validator,
      readOnly: readonly ?? false,
      enabled: enabled,
      keyboardType: textInputtype,
      cursorHeight: 20,
      style: Apptextstyles.smalltextStyle14,
      obscureText: ishidden ?? false,
      maxLines: isMultiline == false || maxlines == null ? 1 : maxlines,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: enableSuggestion ?? false,
      onFieldSubmitted: onFieldSubmitted,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: textfieldname,
        enabled: enabled ?? true,
        labelStyle: Apptextstyles.smalltextStyle14,
        prefixIcon: prefixIcon,
        fillColor: Theme.of(context).canvasColor.withOpacity(0.8),
        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
        hintText: innerHint,
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        suffixIcon: suffixwidget,
        border: border ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.lightgrey,
                )),
      ),
    );
  }
}
