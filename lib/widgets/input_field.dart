import 'package:flutter/material.dart';

import 'input_text_editing_controller.dart';

/// Custom TextFormField with dynamic validator
class InputField extends StatefulWidget {
  const InputField({
    Key? key, 
    this.controller, 
    this.keyboardType, 
    this.hintText, 
    this.validator, 
    this.onChanged, 
    this.onTap,
    this.obscureText,
    this.suffixIcon,
    this.width,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.maxLength,
    this.initialValue
  }) : super(key: key);
  
  final InputTextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool? obscureText;
  final Widget? suffixIcon;
  final double? width;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;
  final String? initialValue;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String? errorText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.5)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          errorText != null 
          ? Text(
            errorText!, 
            style: TextStyle(
              fontSize: 12, 
              color: Theme.of(context).inputDecorationTheme.errorStyle!.color
            )
          )
          : Container(),
          TextFormField(
            initialValue: widget.initialValue,
            readOnly: widget.readOnly,
            key: widget.key,
            obscureText: widget.obscureText?? false,
            onChanged: (String value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              if (widget.validator != null) {
                setState(() {
                  errorText = widget.validator!(value);
                  widget.controller!.isValid = errorText == null;
                });
              }
            },
            onTap: widget.onTap,
            controller: widget.controller,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            style: Theme.of(context).textTheme.bodyText1,
            keyboardType: widget.keyboardType,
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: 18,
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                fontSize: 12,
                color: Theme.of(context).inputDecorationTheme.errorStyle!.color
              ),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyText1,
              suffixIcon: widget.suffixIcon
            )
          )
        ]
      )
    );
  }
}