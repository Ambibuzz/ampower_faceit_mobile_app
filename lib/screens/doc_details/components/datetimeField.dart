import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../viewmodel/docrenderer_viewmodel.dart';
import 'label.dart';

class BuildDateTimeField extends StatefulWidget{
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildDateTimeField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});

  @override
  State<BuildDateTimeField> createState() => _BuildDateTimeField();
}

class _BuildDateTimeField extends State<BuildDateTimeField> {
  bool isEditable = false;
  bool isRequired = false;

  late var controller;
  var text;
  var showError;

  @override
  void initState() {
    isEditable =
        !['Cancelled', 'Approved'].contains(widget.doctype['status']) &&
            widget.fieldInfo['read_only'] != 1 &&
            (widget.fieldInfo['fetch_from'] == null ||
                widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
    isRequired = widget.fieldInfo['reqd'] == 1;
    controller = widget.model.controllers[widget.fieldInfo['fieldname']];
    text = controller?.text ?? '';
    showError = isRequired && text.trim().isEmpty && widget.model.showValidationErrors;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(widget.fieldInfo), // <- Adds red star for required fields
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          onTap:
          isEditable
              ? () async {
            final picked = await showBoardDateTimePicker(
              context: context,
              pickerType: DateTimePickerType.datetime,
              initialDate: DateTime.tryParse(controller?.text ?? ''),
              options: const BoardDateTimeOptions(
                languages: BoardPickerLanguages.en(),
              ),
              maximumDate: DateTime(2040),
              minimumDate: DateTime(1900, 1, 1),
            );

            if (picked != null) {
              controller?.text = DateFormat('dd-MM-yyyy HH:mm:ss').format(picked);
            }
          }
              : null,
          style: TextStyle(color: isEditable ? Colors.black : Colors.grey),
          decoration: InputDecoration(
            hintText: widget.fieldInfo['label'],
            filled: true,
            fillColor: isEditable ? Colors.white : Colors.grey[300],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.grey.shade400,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.blue,
                width: 1.5,
              ),
            ),
            errorText: showError ? 'This field is required' : null,
            errorStyle: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
