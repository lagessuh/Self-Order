import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.labelText,
      this.prefixIcon,
      this.onChanged,
      this.hintText,
      required this.textType,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.onSaved,
      this.controller,
      this.inputFormatter,
      this.expands = false,
      this.initialValue,
      this.enabled = true,
      this.readOnly = false,
      this.onTap});

  final String? hintText, labelText;
  // final Icon? suffixIcon, prefixIcon;
  final Widget? suffixIcon, prefixIcon;
  final void Function(String?)? onChanged;
  final TextInputType textType;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatter;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool? expands;
  final String? initialValue;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      initialValue: initialValue,
      expands: expands!,
      controller: controller,
      obscureText: obscureText!,
      keyboardType: textType,
      onChanged: (value) => onChanged!(value),
      validator: (value) => validator!(value),
      onSaved: (value) => onSaved!(value),
      decoration: InputDecoration(
          labelStyle: !enabled
              ? const TextStyle(color: Colors.red)
              : const TextStyle(color: Colors.black),
          prefixIcon: prefixIcon,
          labelText: labelText,
          suffixIcon: suffixIcon,
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.2),
          )),
      inputFormatters: inputFormatter,
    );
  }
}
