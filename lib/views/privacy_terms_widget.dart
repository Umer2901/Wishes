import 'package:wishes_app/export.dart';

class PrivacyPolicyAndTermsSection extends StatelessWidget {
  final String title;
  final List<String> content;

  const PrivacyPolicyAndTermsSection(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 0.8.h),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.justify,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
