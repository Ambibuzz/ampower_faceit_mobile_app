import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'label.dart';

class BuildDateField extends StatefulWidget {
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildDateField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});

  @override
  State<BuildDateField> createState() => _BuildDateFieldState();
}

class _BuildDateFieldState extends State<BuildDateField> {
  bool isEditable = false;
  bool isRequired = false;

  late final controller;
  String text = '';
  var showError;
  @override
  void initState() {
    isEditable = !['Cancelled', 'Approved'].contains(widget.doctype['status']) && widget.fieldInfo['read_only'] != 1 && (widget.fieldInfo['fetch_from'] == null || widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
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
        buildLabel(widget.fieldInfo),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: isEditable
              ? () async {
            DateTime? picked = await DatePicker.showSimpleDatePicker(
              context,
              initialDate: DateTime.tryParse(controller?.text ?? '') ??
                  DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateFormat: "yyyy-MMMM-dd",
              locale: DateTimePickerLocale.en_us,
              looping: true,
              titleText: "Select date",
              cancelText: "Cancel",
              confirmText: "OK",
              itemTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            );

            if (picked != null) {
              controller?.text = DateFormat('yyyy-MM-dd').format(picked);
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

