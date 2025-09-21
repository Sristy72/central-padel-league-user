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
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            columnSpacing: 12.0,
            horizontalMargin: 12,
            headingRowColor: MaterialStateProperty.all(Colors.black),
            dataRowColor: MaterialStateProperty.all(const Color(0xFFE2E2E2)),
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
            rows: standingsData.map((standing) {
              return DataRow(
                cells: [
                  DataCell(Text(standing.position.toString())),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12.0,
                          backgroundImage:
                              (standing.teamLogoUrl.startsWith('http') ||
                                  standing.teamLogoUrl.startsWith('https'))
                              ? NetworkImage(standing.teamLogoUrl)
                              : AssetImage(standing.teamLogoUrl)
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 8.0),
                        Text(standing.teamName),
                      ],
                    ),
                  ),
                  DataCell(Text(standing.played.toString())),
                  DataCell(Text(standing.won.toString())),
                  DataCell(Text(standing.drawn.toString())),
                  DataCell(Text(standing.lost.toString())),
                  DataCell(Text(standing.goalDifference.toString())),
                  DataCell(Text(standing.points.toString())),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
