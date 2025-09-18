import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import '../widgets/bullet_point.dart';
import '../widgets/pragraph.dart';
import '../widgets/section_title.dart';

class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Your data is protected—learn how we collect,\nuse, and safeguard it.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(text: "Privacy Policy"),
            const SizedBox(height: 16,),
            Pragraph(text: "we value and respect your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your personal information when you visit our website [yourwebsite.com] or make a purchase from us.\nBy using our website, you agree to the practices described in this Privacy Policy. Please read it carefully to understand our views and practices regarding your personal data."),

            SectionTitle(text: "Information We Collect"),
            Pragraph(text: "We collect various types of information to provide and improve our auction services, including:"),
            BulletPoint(text: "Personal Information: Name, email, phone, billing/shipping address, payment details."),
            BulletPoint(text: "Transaction Information: Details of your bidding activity, bids placed, items purchased, and payment history."),
            BulletPoint(text: "Usage Data: Interactions with the site including IP address, browser type, pages visited, and time spent."),
            BulletPoint(text: "Cookies & Tracking Technologies: To enhance your experience and collect info about site usage."),

            SectionTitle(text: "How We Use Your Information"),
            Pragraph(text: "We use the information we collect to:"),
            BulletPoint(text: "Provide and manage services (bids, payments, shipping orders)."),
            BulletPoint(text: "Communicate with you about your account, bids, and purchases."),
            BulletPoint(text: "Respond to customer service inquiries."),
            BulletPoint(text: "Personalize your experience and recommend relevant products."),
            BulletPoint(text: "Analyze and improve the performance of the site."),
            BulletPoint(text: "Ensure compliance with service terms, obligations, and fraud prevention."),

            SectionTitle(text: "How We Share Your Information"),
            Pragraph(text: "We may share your personal information in the following situations:"),
            BulletPoint(text: "Service Providers: Trusted partners for processing payments and services."),
            BulletPoint(text: "Legal Requirements: Disclose personal info if required by law."),
            BulletPoint(text: "Business Transfers: In case of merger, acquisition, or asset sale."),

            SectionTitle(text: "Data Security"),
            Pragraph(text: "We take the security of your personal information seriously. However, no internet transmission is 100% secure."),

            SectionTitle(text: "Your Data Rights"),
            Pragraph(text: "Depending on your location, you may have certain rights regarding your personal data, including:"),
            BulletPoint(text: "The right to access the personal information we hold about you."),
            BulletPoint(text: "The right to correct any inaccuracies in your personal information."),
            BulletPoint(text: "The right to delete your personal information, subject to legal and contractual obligations."),
            BulletPoint(text: "The right to withdraw consent where we process data based on consent."),
            BulletPoint(text: "The right to opt-out of marketing communications."),
            Pragraph(text: "If you wish to exercise any of these rights, please contact us at [contact@yourwebsite.com]."),

            SectionTitle(text: "Data Retention"),
            Pragraph(text: "We retain your personal information for as long as necessary to provide services, comply with legal obligations, and resolve disputes. Once your data is no longer needed, we will securely delete or anonymize it."),

            SectionTitle(text: "Cookies"),
            Pragraph(text: "We use cookies to enhance your browsing experience. You can control cookies via browser settings."),

            SectionTitle(text: "Children’s Privacy"),
            Pragraph(text: "Our site is not intended for children under 13. If data is inadvertently collected, we will delete it."),

            SectionTitle(text: "Changes to This Privacy Policy"),
            Pragraph(text: "We may update this Privacy Policy from time to time. Please review it periodically."),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}