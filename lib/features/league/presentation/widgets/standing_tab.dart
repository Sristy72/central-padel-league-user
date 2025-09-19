import 'package:flutter/material.dart';
import '../../models/standing_model.dart';

class StandingTab extends StatelessWidget {
  final List<Standing> standingsData;

  const StandingTab({super.key, required this.standingsData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        child: DataTable(
          columnSpacing: 12.0,
          horizontalMargin: 12,

          headingRowColor: WidgetStateProperty.all(Colors.black),
          dataRowColor: WidgetStateProperty.all(Color(0xFFE2E2E2)),

          border: const TableBorder(
            horizontalInside: BorderSide(color: Colors.black, width: 10),
          ),

          columns: const [
            DataColumn(
              label: Text(
                'Pos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Team',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'P',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'W',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'D',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'L',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '+/-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'PTS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          rows: standingsData
              .map(
                (team) => DataRow(
                  cells: [
                    DataCell(Text(team.pos.toString())),
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(team.teamLogoPath),
                            radius: 12.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(team.teamName),
                        ],
                      ),
                    ),
                    DataCell(Text(team.p.toString())),
                    DataCell(Text(team.w.toString())),
                    DataCell(Text(team.d.toString())),
                    DataCell(Text(team.l.toString())),
                    DataCell(Text(team.plusMinus.toString())),
                    DataCell(Text(team.pts.toString())),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
