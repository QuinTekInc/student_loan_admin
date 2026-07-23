// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;
  final TextAlign textAlignment;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softwrap;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    this.textColor = Colors.black87,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.textAlignment = TextAlign.left,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.overflow,
    this.softwrap = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        softWrap: softwrap,
        textAlign: textAlignment,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontFamily: "Poppins",
          height: height,
        ),
      ),
    );
  }
}

CustomText HeaderText(
  String text, {
  double fontSize = 20,
  Color textColor = Colors.black87,
  TextAlign textAlignment = TextAlign.left,
}) => CustomText(
  text,
  textColor: textColor,
  fontWeight: FontWeight.bold,
  fontSize: fontSize,
  textAlignment: textAlignment,
  padding: EdgeInsets.zero,
);

//todo: custom text field
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? leadingIcon;
  final Function(String)? onChanged;
  final Widget? suffix;
  final int maxLines;
  final bool obscureText;
  final bool useLabel;
  final Color? fillColor;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlignment;
  final TextInputType keyboardType;
  final Color? borderColor;
  final bool readOnly;
  final VoidCallback? onPressed;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.leadingIcon,
    this.onChanged,
    this.maxLines = 1,
    this.suffix,
    this.obscureText = false,
    this.useLabel = false,
    this.fillColor,
    this.maxLength,
    this.inputFormatters,
    this.textAlignment = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.borderColor,
    this.readOnly = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),

      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        obscureText: obscureText,
        readOnly: readOnly,

        textAlign: textAlignment,

        inputFormatters: inputFormatters,

        onChanged: onChanged,
        onTap: onPressed,
        cursorColor: Colors.green.shade800,

        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(fontFamily: "Poppins"),
          floatingLabelStyle: TextStyle(color: Colors.green.shade400),
          filled: true,
          fillColor: const Color(0xffF1F5F9),
          prefixIcon: Icon(leadingIcon),
          suffix: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

//todo: custom password field

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool useLabel;
  final void Function(String?)? onChanged;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.hintText,
    this.useLabel = true,
    this.onChanged,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      obscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextField(
        controller: widget.controller,
        obscureText: obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.green.shade400,
        decoration: InputDecoration(
          labelText: widget.hintText ?? "Password",
          floatingLabelStyle: TextStyle(color: Colors.green.shade400),
          filled: true,
          fillColor: const Color(0xffF1F5F9),
          prefixIcon: Icon(CupertinoIcons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() => obscureText = !obscureText);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          enabled: true,
        ),
      ),
    );
  }

  Widget buildTrailingIconButton() => GestureDetector(
    onTap: () {
      setState(() {
        obscureText = !obscureText;
      });
    },
    child: Icon(
      obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
      color: Colors.green,
      size: 20,
    ),
  );
}

//todo: build a text area.
class CustomTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;

  const CustomTextArea({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      maxLines: 4,
      maxLength: maxLength,
      hintText: hintText,
      useLabel: false,
    );
  }
}

class OtpTextField extends StatefulWidget {
  final OtpTextEditingController controller;

  const OtpTextField({super.key, required this.controller});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  final List<TextEditingController> textControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: List<Widget>.generate(6, (index) {
          return Expanded(
            child: CustomTextField(
              controller: textControllers[index],
              textAlignment: TextAlign.center,
              keyboardType: TextInputType.number,

              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

              onChanged: (newValue) {
                if (textControllers[index].text.length == 1 && index != 5)
                  FocusScope.of(context).nextFocus();

                String otpText = '';

                //todo: collect the text from every text field in the Otp Text field controllers.
                for (TextEditingController textController in textControllers) {
                  otpText += textController.text;
                }

                widget.controller.text = otpText;
              },
            ),
          );
        }),
      ),
    );
  }
}

class OtpTextEditingController {
  String text;

  OtpTextEditingController({this.text = ''});

  void clear() {
    text = '';
  }
}

class FragementHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  const FragementHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final headerText = HeaderText(title, fontSize: 24);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12,
      children: [
        if (context.read<NavigationCubit>().navigatorStack.length > 1)
          IconButton(
            onPressed: context.read<NavigationCubit>().pop,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.green.shade700,
            ),
          ),

        if (subtitle == null) headerText,

        if (subtitle != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              headerText,

              CustomText(
                subtitle!,
                textColor: Colors.black54,
                padding: EdgeInsets.zero,
              ),
            ],
          ),

        if (actions.isNotEmpty) Spacer(),

        if (actions.isNotEmpty) ...actions,
      ],
    );
  }
}

class TableContainer extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? height;
  final double width;

  final Widget child;

  const TableContainer({
    super.key,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
    this.height,
    this.width = double.infinity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),

      child: child,
    );
  }
}

class TableHeaderContainer extends StatelessWidget {
  final List<Widget> headerChildren;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const TableHeaderContainer({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0,
    this.headerChildren = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),

      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        spacing: spacing,
        children: headerChildren,
      ),
    );
  }
}
