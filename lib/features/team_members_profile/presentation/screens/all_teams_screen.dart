import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/team_details/data/models/team_model.dart';
import 'package:karlfive/features/team_details/presentation/screens/team_details_screens.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/all_teams_controller.dart';

class AllTeamsScreen extends StatelessWidget {
  const AllTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazily put controller using existing TeamRepo registered in DI
    final controller = Get.put(AllTeamsController(repo: Get.find()), tag: 'allTeams');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!, style: const TextStyle(color: Colors.white)));
        }
        final List<TeamModel> teams = controller.teams;
        if (teams.isEmpty) {
          return const Center(child: Text('No teams found', style: TextStyle(color: Colors.white)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: teams.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            final t = teams[index];
            final logo = t.logoPhotoUrl;
            return ListTile(
              onTap: () {
                Get.to(() => TeamDetailsScreen(teamId: t.id));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey[800],
                backgroundImage: (logo.isNotEmpty && logo.startsWith('http'))
                    ? NetworkImage(logo)
                    : null,
                child: (logo.isEmpty) ? const Icon(Icons.group, color: Colors.white) : null,
              ),
              title: Text(t.teamName, style: const TextStyle(color: Colors.white)),
              subtitle: Text(t.captainName, style: const TextStyle(color: Colors.white70)),
              trailing: Text(t.league?.leagueName ?? '', style: const TextStyle(color: Colors.white70)),
            );
          },
        );
      }),
    );
  }
}
