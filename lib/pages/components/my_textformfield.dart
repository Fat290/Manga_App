
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {Key? key,
        required this.hint,
        this.suffixIcon,
        this.onTapSuffixIcon,
        this.obscureText = false,
        this.validator,
        this.onChanged,
        this.onEditingComplete,
        this.controller,
        required this.focusNode,
        required this.prefixIcon,
        this.filled = false,
        this.enabled = true,
        this.initialValue})
      : super(key: key);
  String hint;
  IconData prefixIcon;
  IconData? suffixIcon;
  VoidCallback? onTapSuffixIcon;
  bool obscureText;
  bool filled;
  bool enabled;
  String? initialValue;
  FocusNode focusNode;
  TextEditingController? controller;
  Function()? onEditingComplete;

  String? Function(String?)? validator;
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        onEditingComplete: onEditingComplete,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        focusNode: focusNode ,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:  BorderSide(color: Theme.of(context).colorScheme.background.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.background.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:  BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.red),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: "Inter",
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              suffixIcon,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 20,
            ),
            onPressed: onTapSuffixIcon,
          ),
          filled: filled,
          enabled: enabled,
        ),
      ),
    );
  }
}