import 'dart:convert';
import 'package:flutter/material.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'inputDecoration.dart';
import 'label.dart';

class BuildTableMultiselectField extends StatefulWidget {
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;
  bool isMultiline;

  BuildTableMultiselectField({
    required this.fieldInfo,
    required this.model,
    required this.doctype,
    required this.isMultiline
});

  @override
  State<BuildTableMultiselectField> createState() => _BuildTableMultiselectField();
}

class _BuildTableMultiselectField extends State<BuildTableMultiselectField> {
  bool isEditable = false;
  @override
  void initState() {
    isEditable =
        !['Cancelled', 'Approved'].contains(widget.doctype['status']) &&
            widget.fieldInfo['read_only'] != 1 &&
            (widget.fieldInfo['fetch_from'] == null ||
                widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(widget.fieldInfo),
        const SizedBox(height: 5),
        FutureBuilder(
          future: widget.model.getLinkFieldData({
            'txt': '',
            'doctype': 'Reference',
            'ignore_user_permissions': 0,
            'reference_doctype': 'Lifting Reports',
            'page_length': 10,
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              List<dynamic> options = data['message'];
              options.add({'value': '', 'description': ''});

              return DropdownButtonFormField(
                isExpanded: true,
                value: '',
                items:
                options.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['value']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  widget.model.addEntryFromTableMultiSelect(
                    widget.fieldInfo['fieldname'],
                    newValue ?? '',
                  );
                },
                decoration: inputDecoration(widget.fieldInfo['label']).copyWith(
                  filled: true,
                  fillColor: isEditable ? Colors.white : Colors.grey[300],
                ),
                style: TextStyle(color: isEditable ? Colors.black : Colors.grey),
              );
            } else {
              return const Text("No data available");
            }
          },
        ),
        const SizedBox(height: 10),
        ...List.generate(
          widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']].length,
              (index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 5),
              child: ListTile(
                title: Text(
                  '${widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']][index]['relevant_standards']}',
                ),
                trailing: InkWell(
                  onTap: () {
                    widget.model.removeEntryFromTableMultiSelect(
                      widget.fieldInfo['fieldname'],
                      widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']][index]['relevant_standards'],
                    );
                  },
                  child: const Icon(Icons.close),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}