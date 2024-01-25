import 'package:wishes_app/export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    config();
  }

  config() async {
    BlocProvider.of<AuthenticationCubit>(context)
        .initializeAppAuth(context)
        .whenComplete(() {
      AppCustomNavigator.replace(
        context,
        const AuthWrapper(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset('assets/images/splash.png'),
      ),
    );
  }
}
