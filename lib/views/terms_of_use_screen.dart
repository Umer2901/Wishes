import 'package:wishes_app/export.dart';

class TermOfUseScreen extends StatelessWidget {
  const TermOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AppCustomNavigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Terms of Use',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrivacyPolicyAndTermsSection(
                      title: 'Acceptance of Terms',
                      content: [
                        'By accessing or using the "Wishes" app, you agree to comply with and be bound by these Terms of Use.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'User Accounts',
                      content: [
                        'You must create an account to use certain features of the app.',
                        'You are responsible for maintaining the confidentiality of your account credentials.',
                        'You agree to provide accurate, current, and complete information during the registration process.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'User Conduct',
                      content: [
                        'You are solely responsible for your interactions with other users.',
                        'You agree not to post content that is harmful, offensive, or violates any applicable laws.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Intellectual Property',
                      content: [
                        'The app and its original content, features, and functionality are owned by "Wishes" and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Termination',
                      content: [
                        'We reserve the right to terminate or suspend your account and access to the app for any reason, without notice.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Changes to Terms',
                      content: [
                        'We may update these Terms of Use from time to time. Check this page periodically for updates.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Contact Us',
                      content: [
                        'If you have any questions about these Terms of Use, please contact us at contact@wishes.support.',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
