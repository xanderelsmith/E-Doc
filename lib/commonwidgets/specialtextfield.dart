import 'package:flutter/material.dart';
import 'package:healthai/styles/apptextstyles.dart';

class SpecialTextfield extends StatelessWidget {
  final String? textfieldname;
  final String? innerHint;

  final TextInputType? textInputtype;
  final Widget? suffixwidget;
  final Function? onChanged;
  final TextCapitalization? textCapitalization;

  final Icon? prefixIcon;
  const SpecialTextfield({
    Key? key,
    this.maxlines,
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
  }) : super(key: key);
  final bool? ishidden;
  final bool? enableSuggestion;
  final TextEditingController? controller;
  final int? maxlines;
  final InputBorder? border;
  final bool? isMultiline;

  final EdgeInsets? contentPadding;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      controller: controller,
      keyboardType: textInputtype,
      cursorHeight: 20,
      style: Apptextstyles.normaltextStyle15,
      obscureText: ishidden ?? false,
      maxLines: isMultiline == false || maxlines == null ? 1 : maxlines,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: enableSuggestion ?? false,
      decoration: InputDecoration(
        labelText: textfieldname,
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
                borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}
