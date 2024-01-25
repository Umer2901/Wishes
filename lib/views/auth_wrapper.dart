import 'package:wishes_app/export.dart';
import 'package:wishes_app/views/Auth/user_info.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
      if (state is Authenticated) {
        return const BottomNavBarScreen();
      } else if (state is RegisterAuthentication) {
        return const UserInfoScreen();
      } else {
        return const WelcomeScreen();
      }
    });
  }
}
