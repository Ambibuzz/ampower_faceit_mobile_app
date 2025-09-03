import 'package:flutter/material.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'inputDecoration.dart';
import 'label.dart';

class BuildTextField extends StatefulWidget{
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;
  bool isMultiline;
  BuildTextField({
    required this.fieldInfo,
    required this.model,
    required this.doctype,
    required this.isMultiline
});

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool isEditable = false;
  bool isRequired = false;
  String fieldValue = '';
  bool isError = false;
  @override
  void initState() {
    isEditable =
        !['Cancelled', 'Approved'].contains(widget.doctype['status']) &&
            widget.fieldInfo['read_only'] != 1 &&
            (widget.fieldInfo['fetch_from'] == null || widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
    isRequired = widget.fieldInfo['reqd'] == 1;
    fieldValue = widget.model.controllers[widget.fieldInfo['fieldname']]?.text ?? '';
    isError = isRequired && fieldValue.trim().isEmpty && widget.model.showValidationErrors;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(widget.fieldInfo),
        const SizedBox(height: 5),
        TextField(
          controller: widget.model.controllers[widget.fieldInfo['fieldname']],
          maxLines: widget.isMultiline ? null : 1,
          readOnly: !isEditable,
          keyboardType: (widget.fieldInfo['fieldType'] == 'Float' ||
              widget.fieldInfo['fieldType'] == 'Currency' ||
              widget.fieldInfo['fieldType'] == 'Percent')
              ? const TextInputType.numberWithOptions(decimal: true)
              : widget.fieldInfo['fieldType'] == 'Int'
              ? TextInputType.number
              : TextInputType.text,
          style: TextStyle(color: isEditable ? Colors.black : Colors.grey),
          decoration: inputDecoration(widget.fieldInfo['label']).copyWith(
            filled: true,
            fillColor: isEditable ? Colors.white : Colors.grey[300],
            errorText: isError ? 'This field is required' : null,
          ),
        ),
      ],
    );
  }
}
