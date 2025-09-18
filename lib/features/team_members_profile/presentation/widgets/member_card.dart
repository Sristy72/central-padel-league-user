import 'package:flutter/material.dart';
import '../../models/team_member_model.dart';

class MemberCard extends StatelessWidget {
  final TeamMemberModel member;
  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.imageUrl.isNotEmpty
              ? NetworkImage(member.imageUrl)
              : null,
          child: member.imageUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(member.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          "${member.role} • ${member.level} lvl",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          "${member.matches} matches",
          style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
        ),
      ),
    );
  }
}
