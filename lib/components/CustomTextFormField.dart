import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField {
  static create(
      {TextEditingController? controller,
      String? value,
      String? helper,
      bool readOnly = false,
      VoidCallback? onTap,
      double? height,
      bool enabled = true,
      TextAlign textAlign = TextAlign.start,
      int? maxLength,
      bool required = false,
      FormFieldValidator<String>? validator,
      AutovalidateMode? autoValidateMode,
      VoidCallback? onEditingComplete,
      List<TextInputFormatter>? inputFormatters,
      TextInputType keyboardType = TextInputType.text,
      Color enabledColor = Colors.white,
      Color disabledColor = bgDisabledTextFieldColor,
      TextInputAction textInputAction = TextInputAction.next,
      bool isTransparentBorder = false,
      bool darkMode = false,
      ValueChanged<String>? onChanged,
      String? hint}) {
    TextEditingController contr =
        controller ?? TextEditingController(text: value);

    return Container(
        height: height,
        margin: const EdgeInsets.only(top: 0),
        child: TextFormField(
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          focusNode: FocusNode(),
          textInputAction: textInputAction,
          textAlign: textAlign,
          autovalidateMode: autoValidateMode,
          controller: contr,
          style: darkMode ? textFieldDarkStyle : textFieldStyle,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditingComplete,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            //labelText: hint,
            label: RichText(
              text: TextSpan(
                  text: hint,
                  style: enabled ? hintText : hintDisabledText,
                  children: required
                      ? [const TextSpan(text: ' *', style: textFieldErrorStyle)]
                      : []),
            ),
            labelStyle: hintText,
            floatingLabelStyle: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            fillColor: enabled ? enabledColor : disabledColor,
            filled: true,
            hintStyle: hintText,
            contentPadding: fieldSearchPadding,
            enabledBorder: isTransparentBorder
                ? textFieldInputTransparentBorder
                : textFieldInputBorder,
            disabledBorder: isTransparentBorder
                ? textFieldInputTransparentBorder
                : textFieldInputBorder,
            focusedBorder: isTransparentBorder
                ? textFieldInputTransparentFocusBorder
                : textFieldInputBorder,
            helperText: helper,
            helperMaxLines: 5,
            helperStyle: textFieldHelperStyle,
            errorBorder: textFieldErrorInputBorder,
            focusedErrorBorder: textFieldErrorInputBorder,
            errorStyle: textFieldErrorStyle,
          ),
        ));
  }
}
