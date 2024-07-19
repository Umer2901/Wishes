import 'package:wishes_app/export.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
                      title: 'Information We Collect',
                      content: [
                        'Account Information: When you create an account on "Wishes," we collect your username, email address, and password.',
                        'Profile Information: You have the option to provide additional information such as your profile picture, bio, and other details that you choose to share.',
                        'Posts and Interactions: When you use the App, we collect information about the posts you create, like, comment on, and share. We also collect information about your interactions with other users.',
                        'Emails: The App includes an email feature, and we may collect information related to your email communications.',
                        'Settings: Information about your preferences and settings within the App.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'How We Use Your Information',
                      content: [
                        'To provide and maintain the App\'s functionality.',
                        'To personalize your experience and deliver content tailored to your interests.',
                        'To communicate with you, including responding to your inquiries and providing customer support.',
                        'To improve the App and develop new features.',
                        'To send you updates, notifications, and promotional messages.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Sharing Your Information',
                      content: [
                        'Public Posts: Information you share in your public posts, including likes, comments, and shares, may be visible to other users.',
                        'Third-Party Services: We may share your information with third-party service providers for analytics, hosting, and other purposes outlined in this policy.',
                        'Legal Compliance: We may disclose your information if required by law or to protect our rights.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Your Choices',
                      content: [
                        'You can control the visibility of your information through privacy settings.',
                        'You can opt-out of promotional communications.',
                        'You can delete your account, which will remove your profile and associated information.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Security',
                      content: [
                        'We take reasonable measures to protect your information from unauthorized access, disclosure, alteration, and destruction.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Children\'s Privacy',
                      content: [
                        'The App is not intended for users under the age of 13, and we do not knowingly collect personal information from children.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Changes to This Privacy Policy',
                      content: [
                        'We may update this Privacy Policy to reflect changes to our practices. Check this page periodically for updates.',
                      ],
                    ),
                    PrivacyPolicyAndTermsSection(
                      title: 'Contact Us',
                      content: [
                        'If you have any questions about this Privacy Policy, please contact us at contact@wishes.support.',
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
