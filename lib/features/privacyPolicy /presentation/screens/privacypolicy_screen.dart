import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white70,
        height: 1.5,
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _paragraph(
              "We value and respect your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your personal information when you visit our website or make a purchase from us.",
            ),

            _sectionTitle("Information We Collect"),
            _bullet("Personal Information: Name, email, phone, billing/shipping address, payment details."),
            _bullet("Transaction Information: Details of your bidding activity, bids placed, items purchased, and payment history."),
            _bullet("Usage Data: Interactions with the site including IP address, browser type, pages visited, and time spent."),
            _bullet("Cookies & Tracking Technologies: To enhance your experience and collect info about site usage."),

            _sectionTitle("How We Use Your Information"),
            _bullet("Provide and manage services (bids, payments, shipping orders)."),
            _bullet("Communicate with you about your account, bids, and purchases."),
            _bullet("Respond to customer service inquiries."),
            _bullet("Personalize your experience and recommend relevant products."),
            _bullet("Analyze and improve the performance of the site."),
            _bullet("Ensure compliance with service terms, obligations, and fraud prevention."),

            _sectionTitle("How We Share Your Information"),
            _bullet("Service Providers: Trusted partners for processing payments and services."),
            _bullet("Legal Requirements: Disclose personal info if required by law."),
            _bullet("Business Transfers: In case of merger, acquisition, or asset sale."),

            _sectionTitle("Data Security"),
            _paragraph(
              "We take the security of your personal information seriously. However, no internet transmission is 100% secure.",
            ),

            _sectionTitle("Data Retention"),
            _paragraph(
              "We retain your data as long as necessary for services, compliance, or dispute resolution.",
            ),

            _sectionTitle("Cookies"),
            _paragraph(
              "We use cookies to enhance your browsing experience. You can control cookies via browser settings.",
            ),

            _sectionTitle("Children’s Privacy"),
            _paragraph(
              "Our site is not intended for children under 13. If data is inadvertently collected, we will delete it.",
            ),

            _sectionTitle("Changes to This Privacy Policy"),
            _paragraph(
              "We may update this Privacy Policy from time to time. Please review it periodically.",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
