import 'package:wishes_app/export.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => AppCustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        SizedBox(width: 36.w),
        Center(child: Image.asset('assets/images/appbar.png'))
      ],
    );
  }
}
