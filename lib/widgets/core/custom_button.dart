import 'package:flutter_svg/flutter_svg.dart';
import 'package:wishes_app/export.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final String? icon;
  final Color? iconColor;
  final String label;
  final double? labelFontSize;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool isLoading;
  const CustomButton(
      {super.key,
      required this.height,
      required this.width,
      required this.borderRadius,
      this.borderColor = AppColors.secondaryColor,
      this.icon,
      this.iconColor,
      required this.label,
      this.labelFontSize,
      this.foregroundColor,
      this.backgroundColor,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: isLoading
            ? LoadingIndicator(
                indicatorType: Indicator.ballBeat,
                colors: [foregroundColor ?? AppColors.whiteColor],
                strokeWidth: 2.w,
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          icon!,
                          width: 20.sp,
                          height: 20.sp,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          label,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: foregroundColor ?? AppColors.whiteColor,
                                fontWeight: FontWeight.w700,
                                fontSize: labelFontSize ?? 12.sp,
                              ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: foregroundColor ?? AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: labelFontSize ?? 12.sp,
                        ),
                  ),
      ),
    );
  }
}
