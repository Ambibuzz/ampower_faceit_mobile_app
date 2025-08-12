import 'dart:math';

import 'package:flutter/material.dart';

import '../viewmodel/docrenderer_viewmodel.dart';

class TableBuilder extends StatefulWidget{
  String parentName;
  String fieldName;
  DocRendererViewmodel model;

  TableBuilder({
    required this.parentName,
    required this.fieldName,
    required this.model
});

  @override
  State<TableBuilder> createState() => _TableBuilderState();
}

class _TableBuilderState extends State<TableBuilder> {
  var tableMeta = [];
  var tableData = [];

  List<dynamic> fields = [];


  @override
  void initState() {

    super.initState();
  }

  void toggleRowSelection(bool value, String tableName, String rowName) {
    for (int i = 0; i < widget.model.currentData['docs'].first[tableName].length; i++) {
      if (widget.model.currentData['docs'].first[tableName][i]['name'] == rowName) {
        widget.model.currentData['docs'].first[tableName][i]['is_selected'] = value;
        break;
      }
    }
    setState(() {

    });
  }

  void toggleAllRowSelection(bool value, String tableName) {
    widget.model.tables[tableName]['is_selected'] = value;
    for (int i = 0; i < widget.model.currentData['docs'].first[tableName].length; i++) {
      widget.model.currentData['docs'].first[tableName][i]['is_selected'] = value;
    }
    setState(() {

    });
  }

  String generateRandomString(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return String.fromCharCodes(
      List.generate(
        length,
            (index) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void addRowInChildTable(fieldName) {
    widget.model.currentData['docs'].first[fieldName].add({
      'name': generateRandomString(10),
      'is_selected': false,
    });
    setState(() {

    });
  }

  void deleteRowsFromTable(String tableName) {
    if (widget.model.currentData['docs'].isNotEmpty &&
        widget.model.currentData['docs'].first.containsKey(tableName)) {
      widget.model.currentData['docs'].first[tableName] =
          widget.model.currentData['docs'].first[tableName]
              .where(
                (item) =>
            !(item.containsKey('is_selected') &&
                item['is_selected'] == true),
          )
              .toList();
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    tableMeta = widget.model.currentMeta['docs'].where((index) => index['name'] == widget.parentName).toList();
    tableData = (widget.model.currentData['docs'].first[widget.fieldName] ?? []).map((e) => Map<String, dynamic>.from(e)).toList();
    fields = tableMeta.first['fields'].where((field) =>field['fieldtype'] != 'Column Break' &&field['fieldtype'] != 'Section Break').toList();
    if (fields.length > 6) fields = fields.sublist(0, 6);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.parentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(
                color: Colors.grey,
                width: 0.5,
              ),
              columnSpacing: 20.0,
              dataRowMinHeight: 50.0,
              dataRowMaxHeight: 60.0,
              headingRowHeight: 60.0,
              headingRowColor: MaterialStateProperty.all(Color(0xFFE0E0E0)),
              columns: [
                DataColumn(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Checkbox(
                      value: widget.model.tables[widget.fieldName]?['is_selected'] ?? false,
                      onChanged: (bool? value) {
                        toggleAllRowSelection(value ?? false, widget.fieldName);
                      },
                    ),
                  ),
                ),
                // Second: Action Button Column
                const DataColumn(
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Text("Action"),
                  ),
                ),
                ...fields.map(
                      (field) => DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(field['label'] ?? 'Unknown'),
                    ),
                  ),
                ),
              ],
              rows: tableData.map<DataRow>((row) {
                String rowId = row['name']?.toString() ?? "Unknown";
                return DataRow(
                  selected: row['is_selected'] ?? false,
                  cells: [
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Checkbox(
                          value: row['is_selected'] ?? false,
                          onChanged: (bool? value) {
                            toggleRowSelection(value ?? false, widget.fieldName, rowId);
                          },
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDetailPopup(context, rowId, widget.model, fields, widget.fieldName);
                          },
                          label: const Text("View",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF68712),
                            minimumSize: const Size(74, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward_ios_outlined,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    ...fields.map(
                          (field) => DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          child:
                          Text((row[field['fieldname']] ?? "N/A").toString()),
                        ),
                      ),
                    ),

                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                addRowInChildTable(widget.fieldName);
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text("Add", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF68712),
                minimumSize: const Size(74, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                deleteRowsFromTable(widget.fieldName);
              },
              icon: const Icon(Icons.delete, size: 16, color: Colors.white),
              label: const Text("Delete", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF68712),
                minimumSize: const Size(74, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


void _showDetailPopup(BuildContext context, String rowId,
    DocRendererViewmodel model, List<dynamic> fields, childTableName) {
  var rowData = model.currentData['docs'].first[childTableName]
      .where((element) => element["name"] == rowId)
      .toList()
      .first;

  Map<String, TextEditingController> controllers = {
    for (var field in fields)
      field['fieldname']:
      TextEditingController(
        text: (rowData[field['fieldname']] ?? '').toString(),
      )
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 500,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Row",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: fields.map((field) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: 470,
                              height: 56,
                              child: TextField(
                                controller: controllers[field['fieldname']],
                                onChanged: (value) =>
                                    rowData[field['fieldname']] = value,
                                decoration: InputDecoration(
                                  labelText: field['label'],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          fixedSize: const Size(123, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFF68712)),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFFF68712)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          for (var field in fields) {
                            rowData[field['fieldname']] =
                                controllers[field['fieldname']]!.text;
                          }
                          model.updateRow(childTableName, rowId, rowData);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF68712),
                          fixedSize: const Size(123, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
