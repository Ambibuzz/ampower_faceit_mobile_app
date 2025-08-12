import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_js/javascript_runtime.dart';
import 'dart:math';
import '../../../base_viewmodel.dart';
import '../../doc_details/web_requests/web_requests.dart';
import 'package:light_html_editor/editor.dart';

class DocRendererViewmodel extends BaseViewModel {
  var currentMeta;
  var currentData;
  var modifiedMeta = {};
  bool docLoading = false;
  int selectedMetaIndex = 0;
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> controllers = {};
  Map<String, dynamic> tempChildTableData = {};
  Map<String, List<int>> selectedRows = {};
  var tables = {};
  var workflowState;
  bool showValidationErrors = false;

  void refreshModel() {
    notifyListeners();
  }

  void removeEntryFromTableMultiSelect(
    String fieldName,
    String relevantStandards,
  ) {
    currentData['docs'].first[fieldName].removeWhere(
      (entry) => entry['relevant_standards'] == relevantStandards,
    );
    notifyListeners();
  }

  void addEntryFromTableMultiSelect(String fieldName, String relevantStandard) {
    if (relevantStandard == '') {
      return;
    }
    currentData['docs'].first[fieldName].add({
      'relevant_standards': relevantStandard,
    });
    notifyListeners();
  }

  void updateRow(childTableName, rowId, rowData) {
    List<dynamic> childTable = currentData['docs'].first[childTableName];

    for (var i = 0; i < childTable.length; i++) {
      if (childTable[i]["name"] == rowId) {
        childTable[i] = rowData;
        childTable[i].remove("name");
        break;
      }
    }

    notifyListeners();
  }

  void changeMetaIndex(value) {
    selectedMetaIndex = value;
    notifyListeners();
  }

  Future<void> getDoctype(doctypeName) async {
    var response = await WebRequests().getDoctypeMeta(doctypeName);
    currentMeta = json.decode(response.toString());
    if (currentMeta != null && response!.statusCode == 200) {
    } else {}
  }

  Future<void> getDoctypeData(doctypeName, referenceName) async {
    var response = await WebRequests().getDoctypeDataWithReferenceName(
      doctypeName,
      referenceName,
    );
    currentData = json.decode(response.toString());
    if (currentData != null && response!.statusCode == 200) {
    } else {}
  }

  Future<void> loadDataIntoControllers() async {
    if (currentData == null ||
        currentData['docs'] == null ||
        currentData['docs'].isEmpty) {
      print("Error: currentData['docs'] is null or empty!");
      return;
    }


    for (var field in currentMeta['docs'].first['fields']) {
      if ([
        'Data',
        'Date',
        'Datetime',
        'Text',
        'Link',
        'Small Text',
        'Read Only',
        'Text Editor'
      ].contains(field['fieldtype'])) {
        // when title is there fetch title string without braces and then fetch it
        if (field['fieldname'] == 'title') {
          var fieldname = currentData['docs'].first[field['fieldname']];
          String fieldnameWithoutBraces = fieldname.replaceAll(
            RegExp(r'[{}]'),
            '',
          );
          controllers[field['fieldname']] = TextEditingController(
            text: currentData['docs'].first[fieldnameWithoutBraces] ?? '',
          );
        } else {
          controllers[field['fieldname']] = TextEditingController(
            text: currentData['docs'].first[field['fieldname']] ?? '',
          );
        }
      }
      if ([
        'Float',
        'Int',
        'Currency',
        'Percent',
      ].contains(field['fieldtype'])) {
        if (currentData['docs'].first[field['fieldname']] != null) {
          controllers[field['fieldname']] = TextEditingController(
            text: currentData['docs'].first[field['fieldname']].toString(),
          );
        }
      }
      // if (field['fieldtype'] == 'Text Editor') {
      //   controllers[field['fieldname']] = LightHtmlEditorController(
      //     text: currentData['docs'].first[field['fieldname']] ?? '',
      //   );
      // }
    }
  }

  String evaluateJS(expression) {
    if (expression.trim().isEmpty) {
      return 'true';
    }

    final JavascriptRuntime jsRuntime = getJavascriptRuntime();
    var document = currentData['docs'].first;
    var docJson = jsonEncode(document);

    if (expression.startsWith("eval:")) {
      expression = expression.substring(5).trim();
    }

    // handling shorthand expressions
    final regex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    if (regex.hasMatch(expression)) {
      // wrapping up the expression
      expression = 'doc["$expression"] != null && doc["$expression"] !== ""';
    }

    String jsCode = """
    const doc = $docJson;
    $expression
  """;

    var evalResult = jsRuntime.evaluate(jsCode);
    return evalResult.stringResult;
  }

  Future<void> breakMetaWithOverview() async {
    modifiedMeta = {};
    var modifiedMetaWithOrphanFields = {};
    List<dynamic> fields = currentMeta['docs'].first['fields'];
    List<dynamic> orphanFields = [];

    for (int i = 0; i < fields.length; i++) {
      // this is so that we can handle the select all state of tables
      if (fields[i]['fieldtype'] == 'Table') {
        tables[fields[i]['fieldname']] = {'is_selected': false};
      }
      //----

      if (fields[i]['fieldtype'] == 'Tab Break' &&
          evaluateJS(fields[i]['depends_on'] ?? '') == 'true') {
        String sectionLabel = fields[i]['label'] ?? '';

        if (!modifiedMetaWithOrphanFields.containsKey(sectionLabel)) {
          modifiedMetaWithOrphanFields[sectionLabel] = [];
        }

        int j = i + 1;
        for (; j < fields.length; j++) {
          if (fields[j]['fieldtype'] == 'Tab Break') {
            break;
          }
          if (evaluateJS(fields[j]['depends_on'] ?? '') == 'true') {
            modifiedMetaWithOrphanFields[sectionLabel]!.add(fields[j]);
          }
        }
        i = j - 1;
      } else {
        if(evaluateJS(fields[i]['depends_on'] ?? '') == 'true') {
          orphanFields.add(fields[i]);
        }
      }
    }

    modifiedMeta['Details'] = orphanFields;
    modifiedMeta.addAll(modifiedMetaWithOrphanFields);

    modifiedMeta['Attachements'] = [
      {
        'fieldtype': 'Attachement',
        'label': 'Attachements',
        'parent': modifiedMeta[modifiedMeta.keys.first].first['parent'],
      },
    ];
  }

  void loadMetaAndData(doctypeName, referenceName) async {
    docLoading = true;
    notifyListeners();
    await getDoctype(doctypeName);
    await getDoctypeData(doctypeName, referenceName);
    await loadDataIntoControllers();
    await breakMetaWithOverview();
    await getWorkflowTransition();
    docLoading = false;
    notifyListeners();
  }

  void saveChildTableTemp(String fieldname, List<Map<String, dynamic>> data) {
    tempChildTableData[fieldname] = List<Map<String, dynamic>>.from(data);
    notifyListeners();
  }

  void editDoc(doc, doctypeName, referenceName) async {
    await WebRequests().saveDoc(doc);
    loadMetaAndData(doctypeName, referenceName);
  }

  Future<dynamic> getLinkFieldData(payload) async {
    var linkData = await WebRequests().getLinkData(payload);
    return linkData;
  }

  Future<dynamic> getWorkflowTransition() async {
    workflowState = await WebRequests().getWorkflowTransition(
      currentData['docs'].first,
    );
    workflowState = workflowState['message'];
  }

  Future<dynamic> applyWorkflowTransition(
    String action,
    String doctypeName,
    String referenceName,
  ) async {
    await WebRequests().applyWorkflowTransition(
      currentData['docs'].first,
      action,
    );
    loadMetaAndData(doctypeName, referenceName);
  }
}
