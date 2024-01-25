import 'package:wishes_app/export.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF3BA7FF);
  static const Color secondaryColor = Color(0xFFFF0037);

  static const Color blackColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color grayColor = Color(0xFFEDEDED);

  static const Color fieldFillColor = Color(0xFFF6F6F6);

  static const Color borderColor = Color(0xFFDFDFDF);

  static const Color secondaryButtonColor = Color(0xFF353535);

  static final kEnableBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.sp),
    borderSide: const BorderSide(
      color: borderColor,
    ),
  );

  static final kFocuseBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.sp),
    borderSide: const BorderSide(
      color: AppColors.primaryColor,
    ),
  );

  static final kErrorOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.sp),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  );
}
