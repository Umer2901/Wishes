import 'package:wishes_app/export.dart';

class CustomIconButton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final String label;
  final double? labelFontSize;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool isLoading;
  final String imageUrl;
  const CustomIconButton({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.borderColor = AppColors.secondaryColor,
    required this.label,
    this.labelFontSize,
    this.foregroundColor,
    this.backgroundColor,
    required this.onPressed,
    this.isLoading = false,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: isLoading
            ? LoadingIndicator(
                indicatorType: Indicator.ballBeat,
                colors: [foregroundColor ?? AppColors.whiteColor],
                strokeWidth: 2.w,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imageUrl.toString()),
                  SizedBox(width: 2.w),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: foregroundColor ?? AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: labelFontSize ?? 12.sp,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
