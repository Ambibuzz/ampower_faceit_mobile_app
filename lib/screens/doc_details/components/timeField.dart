import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'label.dart';

class BuildTimeField extends StatefulWidget{
  var fieldInfo;
  DocRendererViewmodel model;
  var doctype;

  BuildTimeField({
    required this.fieldInfo,
    required this.model,
    required this.doctype
});

  @override
  State<BuildTimeField> createState() => _BuildTimeFieldState();
}

class _BuildTimeFieldState extends State<BuildTimeField> {
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
            (widget.fieldInfo['fetch_from'] == null || widget.fieldInfo['fetch_from'].toString().trim().isEmpty);
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
          keyboardType: TextInputType.datetime,
          readOnly: false, // allow manual edit
          onTap: isEditable
              ? () async {
            FocusScope.of(context).requestFocus(FocusNode()); // hide keyboard
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              final now = DateTime.now();
              final time = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
              controller?.text = DateFormat('HH:mm:ss').format(time);
            }
          }
              : null,
          style: TextStyle(color: isEditable ? Colors.black : Colors.grey),
          decoration: InputDecoration(
            hintText: 'HH:mm:ss',
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