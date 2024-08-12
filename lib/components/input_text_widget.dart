import 'package:flutter/material.dart';
import 'package:kana/utils/constants.dart';

class InputTextWidget extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String labelText;
  final String? helperText;
  final String? hintText;
  final String? errorText;
  final bool isEnable;
  final bool isValid;
  final bool canValidate;
  final bool autoCapitalize;
  final bool isObscureText;
  final FocusNode? focusNode;

  final Function(dynamic) onChanged;
  const InputTextWidget({
    super.key,
    required this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText = 'Please enter text',
    this.helperText,
    this.hintText,
    this.errorText,
    this.isEnable = true,
    this.isValid = false,
    this.autoCapitalize = false,
    this.isObscureText = false,
    this.focusNode,
    this.canValidate = false,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  final double _borderRadius = 8.0;
  final double _gapPadding = 8.0;
  final double _borderWidth = 1.0;
  final double _boldBorderWidth = 2.0;

  // Color _validFillColor(bool isValid) {
  //   if (isValid) {
  //     return ColorConstant.inputSuccessFillColor;
  //   }
  //   return ColorConstant.inputErrorFillColor;
  // }

  // Color _enableFillColor(bool isEnable) {
  //   if (isEnable) {
  //     return ColorConstant.inputEnableFillColor;
  //   }
  //   return ColorConstant.inputDisableColor;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.labelText,
            style: const TextStyle(
              fontSize: Constants.fontSize16,
              color: Constants.titleFontColor,
              fontFamily: Constants.circularFontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextField(
          focusNode: widget.focusNode,
          autocorrect: false,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isObscureText,
          textCapitalization: widget.autoCapitalize
              ? TextCapitalization.words
              : TextCapitalization.none,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              // color: Constants.inputErrorMessageColor,
              fontSize: Constants.fontSize14,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            enabled: widget.isEnable,
            // fillColor: widget.canValidate
            //     ? _validFillColor(widget.isValid)
            //     : _enableFillColor(widget.isEnable),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              gapPadding: _gapPadding,
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              borderSide: BorderSide(
                color: Constants.buttonColor,
                width: _borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: _gapPadding,
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              borderSide: BorderSide(
                color: Constants.buttonColor,
                width: _boldBorderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              gapPadding: _gapPadding,
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              borderSide: BorderSide(
                // color: Constants.inputErrorBorderColor,
                width: _borderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              gapPadding: _gapPadding,
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              borderSide: BorderSide(
                // color: Constants.inputErrorBorderColor,
                width: _boldBorderWidth,
              ),
            ),
            labelText: widget.labelText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            hintText: widget.hintText,
            labelStyle: TextStyle(
                color: Colors.blue,
                ),
          ),
          onChanged: ((text) {
            widget.onChanged(text);
          }),
        ),
      ],
    );
  }
}
