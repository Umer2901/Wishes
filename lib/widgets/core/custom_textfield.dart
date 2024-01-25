import 'package:wishes_app/export.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final InputBorder? enableBorder;
  final InputBorder? focusedBorder;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final Function()? onTap;
  final String? initialValue;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool readOnly;
  final Color fillColor;
  final TextInputType keyboardType;
  final int maxLines;
  final int? minLines;
  const CustomTextField({
    super.key,
    required this.name,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enableBorder,
    this.focusedBorder,
    this.validator,
    this.initialValue,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textInputAction = TextInputAction.done,
    this.onTap,
    required this.fillColor,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: FormBuilderTextField(
        textInputAction: textInputAction,
        validator: validator,
        textAlign: textAlign,
        textDirection: textDirection,
        onTap: onTap,
        name: name,
        readOnly: readOnly,
        initialValue: initialValue,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.blackColor),
        cursorColor: AppColors.blackColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(letterSpacing: 1, color: AppColors.blackColor),
          fillColor: fillColor,
          filled: true,
          enabledBorder: enableBorder ?? AppColors.kEnableBorder,
          focusedBorder: focusedBorder ?? AppColors.kFocuseBorder,
          errorBorder: AppColors.kErrorOutlineBorder,
          focusedErrorBorder: AppColors.kErrorOutlineBorder,
        ),
      ),
    );
  }
}
