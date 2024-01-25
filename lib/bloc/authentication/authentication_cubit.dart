import 'package:wishes_app/export.dart';
import 'package:wishes_app/firebase_messaging_service.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessagingServices notificationServices = FirebaseMessagingServices();

  Future<void> authenticate() async {
    await notificationServices.getDeviceToken().then((value) async {
      await UserServices.update(
          FirebaseAuth.instance.currentUser!.uid, {'token': value}, null);
    });
    emit(
      Authenticated(user: FirebaseAuth.instance.currentUser),
    );
  }

  Future<void> initializeAppAuth(BuildContext context) async {
    if (auth.currentUser != null) {
      await UserServices.fetch(auth.currentUser!.uid).then((value) {
        notificationServices.firebaseInit(context);
        notificationServices.requestNotificationPermission();
        notificationServices.setUpInteractMessage(context);
        notificationServices.foregroundMessaging();
        if (value != null) {
          notificationServices.getDeviceToken().then((value) {
            UserServices.update(
                FirebaseAuth.instance.currentUser!.uid, {'token': value}, null);
          });
          emit(Authenticated(user: auth.currentUser));
        } else {
          emit(RegisterAuthentication(user: auth.currentUser));
        }
      });
    } else {
      emit(Unauthenticated());
    }
    await Future.delayed(const Duration(milliseconds: 2000));
  }

  Future<void> phoneAuthentication(
      {required BuildContext context, required String phoneNumber}) async {
    emit(AuthenticationLoading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          emit(
            const AuthenticationError(
              error: 'The provided phone number is not valid.',
            ),
          );
        } else {
          emit(
            const AuthenticationError(
              error: 'Something went wrong. Try again.',
            ),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(SendedCode());
        AppCustomNavigator.replace(
          context,
          OtpScreen(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      },
    );

    await Future.delayed(const Duration(seconds: 5));
    emit(AuthenticationInitial());
  }

  Future<void> verifyOTP(
      BuildContext context, String otp, String verificationId) async {
    emit(VerifyCode());
    try {
      var credential = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
      AppUser? appUser = await UserServices.fetch(credential.user!.uid);

      if (appUser != null) {
        await notificationServices.getDeviceToken().then((value) async {
          await UserServices.update(
              FirebaseAuth.instance.currentUser!.uid, {'token': value}, null);
        });
        emit(Authenticated(user: auth.currentUser));
      } else {
        emit(RegisterAuthentication(user: auth.currentUser));
      }
    } catch (e) {
      emit(AuthenticationError(error: e.toString()));
    }
  }

  Future<void> googleAuthentication() async {
    emit(AuthenticationLoading());
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);

    AppUser? appUser = await UserServices.fetch(user.user!.uid);

    if (appUser != null) {
      await notificationServices.getDeviceToken().then((value) async {
        await UserServices.update(
            FirebaseAuth.instance.currentUser!.uid, {'token': value}, null);
      });
      emit(Authenticated(user: auth.currentUser));
    } else {
      emit(RegisterAuthentication(user: auth.currentUser));
    }
  }

  Future<void> signout() async {
    try {
      await UserServices.update(
          FirebaseAuth.instance.currentUser!.uid, {'token': null}, null);

      await FirebaseAuth.instance.signOut();

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthenticationError(error: e.toString()));
    }
  }
}
