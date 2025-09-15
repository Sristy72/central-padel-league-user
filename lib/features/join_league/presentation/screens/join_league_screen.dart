import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import '../controller/join_league_controller.dart';
import '../widgets/aptain_name_field.dart';
import '../widgets/team_name_field.dart';
import '../widgets/partner_name_field.dart';
import '../widgets/player_level_dropdown.dart';
import '../widgets/email_field.dart';
import '../widgets/contact_number_field.dart';
import '../widgets/upload_logo_widget.dart';
import '../widgets/league_field.dart';
import '../widgets/agreement_checkboxes.dart';
import '../widgets/submit_button.dart';

class JoinLeagueScreen extends StatefulWidget {
  const JoinLeagueScreen({super.key});

  @override
  State<JoinLeagueScreen> createState() => _JoinLeagueScreenState();
}

class _JoinLeagueScreenState extends State<JoinLeagueScreen> {
  final joinLeagueController = Get.find<JoinLeagueController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: joinLeagueController.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Gap.h20,

                            /// [Title]
                            Text("Join League"),
                            Gap.h8,

                            /// [Subtitle]
                            Text("Build your team and join the league—add players, set details, and get ready to compete!"),
                            Gap.h24,

                            /// [Team Name Field]
                            const TeamNameField(),
                            Gap.h16,

                            /// [Captain Name Field]
                            const CaptainNameField(),
                            Gap.h16,

                            /// [Partner Name Field]
                            const PartnerNameField(),
                            Gap.h16,

                            /// [Player Levels Dropdown]
                            const PlayerLevelDropdown(),
                            Gap.h16,

                            /// [Email Field]
                            const EmailField(),
                            Gap.h16,

                            /// [Contact Number Field]
                            const ContactNumberField(),
                            Gap.h16,

                            /// [Upload Logo Section]
                            const UploadLogoWidget(),
                            Gap.h16,

                            /// [Select League Field]
                            const LeagueField(),
                            Gap.h16,

                            /// [Agreement Checkboxes]
                            const AgreementCheckboxes(),
                            Gap.h24,

                            /// [Apply to League Button]
                            const SubmitButton(),
                            Gap.h20,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
