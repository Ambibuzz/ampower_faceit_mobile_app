import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../viewmodel/docrenderer_viewmodel.dart';

class BuildCheckBoxField extends StatefulWidget{
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildCheckBoxField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});
  @override
  State<BuildCheckBoxField> createState() => _BuildCheckBoxFieldState();
}

class _BuildCheckBoxFieldState extends State<BuildCheckBoxField> {
  bool isEditable = false;
  @override
  void initState() {
    isEditable = !['Cancelled', 'Approved'].contains(widget.doctype['status']) && widget.fieldInfo['read_only'] != 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']] == 1,
          onChanged: isEditable
              ? (bool? newValue) {
            widget.model.currentData['docs'].first[widget.fieldInfo['fieldname']] = newValue! ? 1 : 0;
            setState(() {

            });
          }
              : null,
        ),
        Text(
          widget.fieldInfo['label'] ?? '',
          style: TextStyle(
            color: isEditable ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
