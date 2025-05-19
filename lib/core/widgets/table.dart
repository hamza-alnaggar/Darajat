import 'package:flutter/material.dart';

class DataTablePage extends StatelessWidget {
  final List<Map<String, String>> rows;

  const DataTablePage({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Filename')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Date')),
        ],
        rows: rows.map((row) => DataRow(
          cells: [
            DataCell(ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                row['filename']!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )),
            DataCell(Text(row['type']!)),
            DataCell(Text(
              row['status']!,
              style: TextStyle(
                color: row['status'] == 'Failed' 
                  ? Colors.red 
                  : Colors.green,
              ),
            )),
            DataCell(Text(row['date']!)),
          ],
        )).toList(),
      ),
    );
  }
}