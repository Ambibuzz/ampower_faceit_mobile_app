import 'dart:convert';
import 'package:flutter/material.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'inputDecoration.dart';
import 'label.dart';

class BuildLinkField extends StatefulWidget{
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildLinkField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});

  @override
  State<BuildLinkField> createState() => _BuildLinkFieldState();
}

class _BuildLinkFieldState extends State<BuildLinkField> {
  bool isEditable = false;
  @override
  void initState() {
    isEditable = !['Cancelled', 'Approved'].contains(widget.doctype['status']) &&
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
            'doctype': widget.fieldInfo['options'],
            'ignore_user_permissions': 0,
            'reference_doctype': 'Lifting Reports',
            'page_length': 10
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              List<dynamic> options = data['message'];

              // Extract the initial value from the model
              String? initialValue = widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']];
              bool hasInitialValue = options.any((item) => item['value'] == initialValue);

              if(!hasInitialValue){
                initialValue = null;
              }

              return DropdownButtonFormField(
                isExpanded: true,
                value: initialValue,
                items: options.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['value']),
                  );
                }).toList(),
                onChanged: isEditable
                    ? (newValue) {
                  widget.model.controllers[widget.fieldInfo['fieldname']]?.text = newValue.toString() ?? '';
                }
                    : null,
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
      ],
    );
  }
}
