import 'package:community/screens/doc_details/components/selectField.dart';
import 'package:community/screens/doc_details/components/tableBuilder.dart';
import 'package:community/screens/doc_details/components/tableMultiselect.dart';
import 'package:community/screens/doc_details/components/textField.dart';
import 'package:community/screens/doc_details/components/timeField.dart';
import 'package:flutter/material.dart';
import 'attachementField.dart';
import 'buildCheckboxField.dart';
import 'dateField.dart';
import 'datetimeField.dart';
import 'linkField.dart';

Widget fieldRenderer(fieldInfo, context, model, doctype) {
  String parent = fieldInfo['parent'];
  if((fieldInfo['hidden'] != null && fieldInfo['hidden'] == 1) ||
      (fieldInfo['report_hide'] != null && fieldInfo['report_hide'] == 1) ||
      (fieldInfo['is_virtual'] != null && fieldInfo['is_virtual'] == 1) ||
      (fieldInfo['read_only'] != null && fieldInfo['read_only'] == 1 && (model.currentData['docs'].first[fieldInfo['fieldname']] == null))
  ){
    return Container();
  }

  switch (fieldInfo['fieldtype']) {
    case 'Column Break':
      return const SizedBox(width: 16); // Creates spacing for column layout

    case 'Section Break' when parent == doctype['doctype']:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 400),
          Text(
            fieldInfo['label'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 10),
        ],
      );

    case final type when ['Currency', 'Data', 'Float', 'Percent', 'Int', 'Read Only'].contains(type) && parent == doctype['doctype']:
      return BuildTextField(fieldInfo: fieldInfo, model: model, doctype: doctype, isMultiline: false);

    case 'Link' when parent == doctype['doctype']:
      return BuildLinkField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    case final type when ['Text', 'Small Text', 'Text Editor'].contains(type) && parent == doctype['doctype']:
      return BuildTextField(fieldInfo: fieldInfo, model: model, doctype: doctype, isMultiline: true);

    case 'Date' when parent == doctype['doctype']:
      return BuildDateField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    case 'Datetime' when parent == doctype['doctype']:
      return BuildDateTimeField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    case 'Time' when parent == doctype['doctype']:
      return BuildTimeField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    case 'Select' when parent == doctype['doctype']:
      return BuildSelectField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    case 'Table' when parent == doctype['doctype']:
      return TableBuilder(parentName: fieldInfo['options'], fieldName: fieldInfo['fieldname'], model: model);

    case 'Table MultiSelect' when parent == doctype['doctype']:
      return BuildTableMultiselectField(fieldInfo: fieldInfo, model: model, doctype: doctype, isMultiline: true);

    case 'Attachement' when parent == doctype['doctype']:
      return buildAttachementField(parent, context, doctype);

    case 'Check' when parent == doctype['doctype']:
      return BuildCheckBoxField(fieldInfo: fieldInfo, model: model, doctype: doctype);

    default:
      return Container();
      return ListTile(
        title: Text('${fieldInfo['label']}'),
        subtitle: Text('${fieldInfo['fieldtype']}'),
      );
  }
}
