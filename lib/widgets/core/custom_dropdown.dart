import 'package:wishes_app/export.dart';

class CustomDropdown extends StatelessWidget {
  final String name;
  final String hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final InputBorder? enableBorder;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final Function()? onTap;
  final String? initialValue;
  final bool readOnly;
  final Color fillColor;
  final void Function(dynamic)? onChanged;
  final TextInputType keyboardType;
  final List<DropdownMenuItem> items;
  const CustomDropdown(
      {super.key,
      required this.name,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.enableBorder,
      this.validator,
      this.initialValue,
      this.textInputAction = TextInputAction.done,
      this.onTap,
      required this.fillColor,
      this.readOnly = false,
      this.keyboardType = TextInputType.name,
      this.onChanged,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: FormBuilderDropdown(
        onTap: onTap,
        name: name,
        initialValue: initialValue,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.primaryColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 1,
                color: AppColors.blackColor,
              ),
          fillColor: fillColor,
          filled: true,
          enabledBorder: enableBorder ?? AppColors.kEnableBorder,
          focusedBorder: AppColors.kFocuseBorder,
          errorBorder: AppColors.kErrorOutlineBorder,
          focusedErrorBorder: AppColors.kErrorOutlineBorder,
        ),
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
