import 'package:flutter/material.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'inputDecoration.dart';
import 'label.dart';

class BuildSelectField extends StatefulWidget {
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildSelectField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});

  @override
  State<BuildSelectField> createState() => _BuildSelectFieldState();
}

class _BuildSelectFieldState extends State<BuildSelectField> {
  bool isEditable = false;
  List<String> options = [''];
  @override
  void initState() {
    isEditable = !['Cancelled', 'Approved'].contains(widget.doctype['status']) &&
        widget.fieldInfo['read_only'] != 1 &&
        (widget.fieldInfo['fetch_from'] == null ||
            widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
    options = widget.fieldInfo['options'].split('\n');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(widget.fieldInfo),
        const SizedBox(height: 5),
        AbsorbPointer(
          absorbing: !isEditable,
          child: DropdownButtonFormField<String>(
            decoration: inputDecoration(widget.fieldInfo['label']).copyWith(
              filled: true,
              fillColor: isEditable ? Colors.white : Colors.grey[300],
            ),
            hint: const Text('Select an option'),
            value: widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']],
            onChanged: isEditable
                ? (String? newValue) {
              if (newValue != null) {
                widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']] = newValue;
              }
            }
                : null,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                        color: isEditable ? Colors.black : Colors.grey)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
