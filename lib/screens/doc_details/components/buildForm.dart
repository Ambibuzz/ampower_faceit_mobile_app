// import 'package:flutter/material.dart';
//
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'depends_on_helper.dart';
// import 'fieldRenderer.dart';
//
// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<Widget> columns = [];
//   List<Widget> currentColumnFields = [];
//
//   for (var field in model.modifiedMeta[model.modifiedMeta.keys.elementAt(model.selectedMetaIndex)]) {
//     if (field['fieldtype'] == 'Section Break') {
//       if (currentColumnFields.isNotEmpty) {
//         columns.add(
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: currentColumnFields,
//             ),
//           ),
//         );
//         columns.add(Text(
//           field['label'] ?? '',
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         )); // Add spacing between columns
//         currentColumnFields = [];
//       }
//     } else if (field['fieldtype'] == 'Column Break') {
//       // Push the current column and start a new one
//       if (currentColumnFields.isNotEmpty) {
//         columns.add(
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: currentColumnFields,
//             ),
//           ),
//         );
//         columns.add(const SizedBox(width: 20)); // Add spacing between columns
//         currentColumnFields = [];
//       }
//     } else {
//       currentColumnFields.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//           child: fieldRenderer(field, context, model, doctype),
//         ),
//       );
//     }
//   }
//
//   // for (var field in model.modifiedMeta[model.modifiedMeta.keys.elementAt(model.selectedMetaIndex)]) {
//   //   // Skip field if depends_on returns false
//   //   if (!evaluateDependsOn(field['depends_on'], model.currentData['docs'].first)) {
//   //     continue;
//   //   }
//   //
//   //   if (field['fieldtype'] == 'Section Break') {
//   //     if (currentColumnFields.isNotEmpty) {
//   //       columns.add(
//   //         Flexible(
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: currentColumnFields,
//   //           ),
//   //         ),
//   //       );
//   //       columns.add(Text(
//   //         field['label'] ?? '',
//   //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//   //       ));
//   //       currentColumnFields = [];
//   //     }
//   //   } else if (field['fieldtype'] == 'Column Break') {
//   //     if (currentColumnFields.isNotEmpty) {
//   //       columns.add(
//   //         Flexible(
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: currentColumnFields,
//   //           ),
//   //         ),
//   //       );
//   //       columns.add(const SizedBox(width: 20));
//   //       currentColumnFields = [];
//   //     }
//   //   } else {
//   //     currentColumnFields.add(
//   //       Padding(
//   //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//   //         child: fieldRenderer(field, context, model, doctype),
//   //       ),
//   //     );
//   //   }
//   // }
//
//
//   // Add last column if it has fields
//   if (currentColumnFields.isNotEmpty) {
//     columns.add(
//       Flexible(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: currentColumnFields,
//         ),
//       ),
//     );
//   }
//
//   columns.add(const Text(''));
//
//   List<Widget> column = [];
//   List<Widget> row = [];
//   for (var widget in columns) {
//     if (widget is Text) {
//       column.add(Wrap(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: row,
//           ),
//           const Divider(),
//           widget
//         ],
//       ));
//       row = [];
//     } else {
//       row.add(widget);
//     }
//   }
//
//   return Form(
//     key: model.formKey,
//     child: SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: column.isNotEmpty ? column : [Container()],
//         ),
//       ),
//     ),
//   );
// }

//
//
//
// import 'package:flutter/material.dart';
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'fieldRenderer.dart';
//
// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<String> tabLabels = model.modifiedMeta.keys.map((e) => e.toString()).toList();
//   List<Widget> tabs = tabLabels.map((label) => Tab(text: label)).toList();
//
//   List<Widget> tabViews = tabLabels.map((tabLabel) {
//     var rawFields = model.modifiedMeta[tabLabel];
//
//     List<Map<String, dynamic>> fields = [];
//
//     // ✅ Correctly flatten the nested structure: tab -> section -> columns -> fields
//     if (rawFields is Map) {
//       rawFields.forEach((sectionLabel, columns) {
//         if (columns is List) {
//           for (var column in columns) {
//             if (column is List) {
//               for (var field in column) {
//                 if (field is Map<String, dynamic>) {
//                   fields.add(field);
//                 }
//               }
//             }
//           }
//         }
//       });
//     }
//
//     // Optional debug prints
//     print("TAB: $tabLabel -> Loaded ${fields.length} fields");
//     for (var f in fields) {
//       print("FIELD: ${f['fieldname']} - ${f['fieldtype']}");
//     }
//
//     List<Widget> formWidgets = [];
//     List<Widget> currentRow = [];
//
//     for (var field in fields) {
//       if (field['fieldtype'] == 'Section Break') {
//         if (currentRow.isNotEmpty) {
//           formWidgets.add(Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: currentRow,
//           ));
//           currentRow = [];
//         }
//         formWidgets.add(Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Text(
//             field['label'] ?? '',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ));
//       } else if (field['fieldtype'] == 'Column Break') {
//         if (currentRow.isNotEmpty) {
//           formWidgets.add(Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: currentRow,
//           ));
//           currentRow = [];
//         }
//       } else {
//         currentRow.add(
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: fieldRenderer(field, context, model, doctype),
//             ),
//           ),
//         );
//       }
//     }
//
//     if (currentRow.isNotEmpty) {
//       formWidgets.add(Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: currentRow,
//       ));
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: formWidgets,
//       ),
//     );
//   }).toList();
//
//   return DefaultTabController(
//     length: tabs.length,
//     child: Column(
//       children: [
//         TabBar(
//           isScrollable: true,
//           labelColor: Theme.of(context).primaryColor,
//           tabs: tabs,
//         ),
//         Expanded(
//           child: TabBarView(
//             children: tabViews,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'depends_on_helper.dart';
// import 'fieldRenderer.dart';

// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<String> tabLabels = model.modifiedMeta.keys.map((e) => e.toString()).toList();
//
//   List<Widget> tabs = tabLabels.map((label) => Tab(text: label)).toList();
//
//   List<Widget> tabViews = tabLabels.map((tabLabel) {
//     var rawFields = model.modifiedMeta[tabLabel];
//     List<Map<String, dynamic>> fields = [];
//
//     // Flatten the structure: Tab → Sections → Columns → Fields
//     if (rawFields is Map) {
//       rawFields.forEach((sectionLabel, columns) {
//         if (columns is List) {
//           for (var column in columns) {
//             if (column is List) {
//               for (var field in column) {
//                 if (field is Map<String, dynamic>) {
//                   fields.add(field);
//                 }
//               }
//             }
//           }
//         }
//       });
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: model.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: fields.map((field) {
//             // ✅ Check depends_on before rendering
//             if (field.containsKey('depends_on') &&
//                 !evaluateDependsOn(field['depends_on'], model.currentData['docs'].first)) {
//               return const SizedBox.shrink();
//             }
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//               child: fieldRenderer(field, context, model, doctype),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }).toList();
//
//   return DefaultTabController(
//     length: tabs.length,
//     child: Column(
//       children: [
//         TabBar(
//           isScrollable: true,
//           tabs: tabs,
//         ),
//         Expanded(
//           child: TabBarView(
//             children: tabViews,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<Widget> columns = []; // Holds all columns created during iteration
//   List<Widget> currentColumnFields = []; // Accumulates fields for the current column
//
//   // Iterate through the fields in the selected tab
//   for (var field in model.modifiedMeta[model.modifiedMeta.keys.elementAt(model.selectedMetaIndex)]) {
//
//     // Handling Section Breaks
//     if (field['fieldtype'] == 'Section Break') {
//       // When we encounter a section break, add the current column to columns and reset currentColumnFields
//       if (currentColumnFields.isNotEmpty) {
//         columns.add(
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: currentColumnFields,
//             ),
//           ),
//         );
//         currentColumnFields = []; // Reset the column fields
//       }
//
//       // Add the section title as a separate widget after section break
//       columns.add(Text(
//         field['label'] ?? 'Section Break',
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//       ));
//     }
//
//     // Handling Column Breaks
//     else if (field['fieldtype'] == 'Column Break') {
//       // When we encounter a column break, add the current column to columns and reset currentColumnFields
//       if (currentColumnFields.isNotEmpty) {
//         columns.add(
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: currentColumnFields,
//             ),
//           ),
//         );
//         columns.add(const SizedBox(width: 20)); // Add spacing between columns
//         currentColumnFields = []; // Reset the column fields for the next column
//       }
//     }
//
//     // For fields (that aren't breaks), add them to the current column
//     else {
//       currentColumnFields.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//           child: fieldRenderer(field, context, model, doctype), // Render each field
//         ),
//       );
//     }
//   }
//
//   // After the loop, if there are any remaining fields in the last column, add them
//   if (currentColumnFields.isNotEmpty) {
//     columns.add(
//       Flexible(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: currentColumnFields,
//         ),
//       ),
//     );
//   }
//
//   // Return the final layout with all columns arranged
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: columns,
//       ),
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'depends_on_helper.dart';
// import 'fieldRenderer.dart';
//
// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<String> tabLabels = model.modifiedMeta.keys.map((e) => e.toString()).toList();
//
//   List<Widget> tabs = tabLabels.map((label) => Tab(text: label)).toList();
//
//   List<Widget> tabViews = tabLabels.map((tabLabel) {
//     var rawFields = model.modifiedMeta[tabLabel];
//     List<Map<String, dynamic>> fields = [];
//     List<Widget> rows = []; // Will hold Row widgets representing columns in a row
//     List<Widget> currentColumnFields = [];
//
//     if (rawFields is Map) {
//       rawFields.forEach((sectionLabel, columnsData) {
//         if (columnsData is List) {
//           for (var column in columnsData) {
//             if (column is List) {
//               currentColumnFields = [];
//
//               for (var field in column) {
//                 if (field is Map<String, dynamic>) {
//                   if (field['fieldtype'] == 'Section Break') {
//                     rows.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           field['label'] ?? 'Section Break',
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                       ),
//                     );
//                   } else if (field['fieldtype'] == 'Column Break') {
//                     // Skip as handled by layout
//                   } else {
//                     currentColumnFields.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                         child: fieldRenderer(field, context, model, doctype),
//                       ),
//                     );
//                   }
//                 }
//               }
//
//               // Wrap this column in Expanded inside a Row
//               rows.add(
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: currentColumnFields,
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             }
//           }
//         }
//       });
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: model.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: rows,
//         ),
//       ),
//     );
//   }).toList();
//
//   return DefaultTabController(
//     length: tabs.length,
//     child: Column(
//       children: [
//         TabBar(
//           isScrollable: true,
//           tabs: tabs,
//         ),
//         Expanded(
//           child: TabBarView(
//             children: tabViews,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// below code is working?

// import 'package:flutter/material.dart';
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'depends_on_helper.dart';
// import 'fieldRenderer.dart';
//
// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   List<String> tabLabels =
//       model.modifiedMeta.keys.map((e) => e.toString()).toList();
//   List<Widget> tabs = tabLabels.map((label) => Tab(text: label)).toList();
//
//   List<Widget> tabViews = tabLabels.map((tabLabel) {
//     var rawFields = model.modifiedMeta[tabLabel];
//
//     List<Widget> sectionWidgets = [];
//
//     if (rawFields is Map) {
//       rawFields.forEach((sectionLabel, columnsData) {
//         if (columnsData is List) {
//           for (var columnList in columnsData) {
//             // This columnList is one row → multiple columns
//             if (columnList is List) {
//               List<Widget> columnWidgets = [];
//               List<Widget> currentColumnFields = [];
//
//               for (var field in columnList) {
//                 if (field is Map<String, dynamic>) {
//                   String fieldType = field['fieldtype'] ?? '';
//
//                   if (fieldType == 'Column Break') {
//                     // Push current column and start a new one
//                     columnWidgets.add(
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: currentColumnFields,
//                         ),
//                       ),
//                     );
//                     currentColumnFields = [];
//                   } else if (fieldType == 'Section Break') {
//                     // Section break within row – not common, but handle it
//                     sectionWidgets.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         child: Text(
//                           field['label'] ?? 'Section',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     );
//                   } else {
//                     currentColumnFields.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8, horizontal: 10),
//                         child: fieldRenderer(field, context, model, doctype),
//                       ),
//                     );
//                   }
//                 }
//               }
//
//               // Push remaining fields as final column
//               if (currentColumnFields.isNotEmpty) {
//                 columnWidgets.add(
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: currentColumnFields,
//                     ),
//                   ),
//                 );
//               }
//
//               // Wrap the row of columns
//               sectionWidgets.add(
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: columnWidgets,
//                   ),
//                 ),
//               );
//             }
//           }
//         }
//       });
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: model.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: sectionWidgets,
//         ),
//       ),
//     );
//   }).toList();
//
//   return DefaultTabController(
//     length: tabs.length,
//     child: Column(
//       children: [
//         TabBar(
//           isScrollable: true,
//           tabs: tabs,
//         ),
//         Expanded(
//           child: TabBarView(
//             children: tabViews,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import '../viewmodel/docrenderer_viewmodel.dart';
// import 'fieldRenderer.dart';
//
// Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
//   // Extract tab labels (keys of model.modifiedMeta) and map them to tabs
//   List<String> tabLabels = model.modifiedMeta.keys.map((e) => e.toString()).toList();
//   List<Widget> tabs = tabLabels.map((label) => Tab(text: label)).toList();
//
//   // Define Tab views based on the content under each tab label
//   List<Widget> tabViews = tabLabels.map((tabLabel) {
//     var rawFields = model.modifiedMeta[tabLabel];
//
//     List<Widget> sectionWidgets = [];
//
//     if (rawFields is Map) {
//       rawFields.forEach((sectionLabel, columnsData) {
//         if (columnsData is List) {
//           // This columnsData represents a list of rows (each row can have multiple columns)
//           for (var columnList in columnsData) {
//             // This columnList is one row → multiple columns
//             if (columnList is List) {
//               List<Widget> columnWidgets = [];
//               List<Widget> currentColumnFields = [];
//
//               // Process each field in the column
//               for (var field in columnList) {
//                 if (field is Map<String, dynamic>) {
//                   String fieldType = field['fieldtype'] ?? '';
//
//                   if (fieldType == 'Column Break') {
//                     // Add the current set of column fields and start a new column
//                     if (currentColumnFields.isNotEmpty) {
//                       columnWidgets.add(
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: currentColumnFields,
//                           ),
//                         ),
//                       );
//                       currentColumnFields = [];
//                     }
//                   } else if (fieldType == 'Section Break') {
//                     // Add a section break inside the column and add label
//                     sectionWidgets.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         child: Row(
//                           children: [
//                             Icon(Icons.segment, color: Colors.blueGrey),
//                             const SizedBox(width: 8),
//                             Text(
//                               field['label'] ?? 'Section',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                     sectionWidgets.add(const Divider(thickness: 2.5));
//                   } else {
//                     // Process normal field (non-break types)
//                     currentColumnFields.add(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         child: fieldRenderer(field, context, model, doctype),
//                       ),
//                     );
//                   }
//                 }
//               }
//
//               // After finishing a column, add any remaining fields
//               if (currentColumnFields.isNotEmpty) {
//                 columnWidgets.add(
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: currentColumnFields,
//                     ),
//                   ),
//                 );
//               }
//
//               // Wrap the columns inside a Row and add it to sectionWidgets
//               sectionWidgets.add(
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: columnWidgets,
//                   ),
//                 ),
//               );
//             }
//           }
//         }
//       });
//     }
//
//     // Return the tab content (fields inside a scrollable form)
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: model.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: sectionWidgets,
//         ),
//       ),
//     );
//   }).toList();
//
//   // Return the DefaultTabController with tabs and their respective views
//   return DefaultTabController(
//     length: tabs.length,
//     child: Column(
//       children: [
//         TabBar(
//           isScrollable: true,
//           tabs: tabs,
//         ),
//         Expanded(
//           child: TabBarView(
//             children: tabViews,
//           ),
//         ),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import '../../../helpers/mediaqueries.dart';
import '../viewmodel/docrenderer_viewmodel.dart';
import 'fieldRenderer.dart';

Widget buildForm(BuildContext context, DocRendererViewmodel model, doctype) {
  List<Widget> columns = [];
  List<Widget> currentColumnFields = [];
  // used prev and current section label so that when next section
  // break comes i store fields in expansion tile and clear column fields
  var prevSectionLabel = '';
  var currSectionLabel = '';
  var prevSectionCollapsible = 0;
  var currSectionCollapsible = 0;
  List<Widget> sections = [];
  bool isFirstSectionBreak = true;
  for (var field in model.modifiedMeta[model.modifiedMeta.keys.elementAt(model.selectedMetaIndex,)]) {
    if (field['fieldtype'] == 'Section Break') {
      if (isFirstSectionBreak == true) {
        prevSectionLabel = field['label'] ?? '';
        currSectionLabel = field['label'] ?? '';
        prevSectionCollapsible = field['collapsible'] ?? 0;
        currSectionCollapsible = field['collapsible'] ?? 0;
        isFirstSectionBreak = false;
      } else {
        prevSectionLabel = currSectionLabel;
        currSectionLabel = field['label'] ?? '';
        prevSectionCollapsible = currSectionCollapsible;
        currSectionCollapsible = field['collapsible'] ?? 0;
      }
      if (currentColumnFields.isNotEmpty) {
        columns.add(
          Flexible(
            child: ExpansionTile(
              title: Text(
                prevSectionLabel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              initiallyExpanded: prevSectionCollapsible == 0,
              children: currentColumnFields,
            ),
          ),
        );
        columns.add(
          Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ); // Add spacing between columns
        currentColumnFields = [];
      }
    } else if (field['fieldtype'] == 'Column Break') {
      if (displayWidth(context) < 800) {
      }
      else {
        // Push the current column and start a new one
        if (currentColumnFields.isNotEmpty) {
          columns.add(
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: currentColumnFields,
              ),
            ),
          );
          columns.add(const SizedBox(width: 20)); // Add spacing between columns
          currentColumnFields = [];
        }
      }
    } else {
      currentColumnFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: fieldRenderer(field, context, model, doctype),
        ),
      );
    }
  }

  // Add last column if it has fields
  if (currentColumnFields.isNotEmpty) {
    columns.add(
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: currentColumnFields,
        ),
      ),
    );
  }

  columns.add(Text(''));

  List<Widget> column = [];
  List<Widget> row = [];
  for (var widget in columns) {
    if (widget is Text) {
      column.add(
        Wrap(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: row),
            // Divider(),
            widget,
          ],
        ),
      );
      row = [];
    } else {
      row.add(widget);
    }
  }

  return Form(
    key: model.formKey,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: column.isNotEmpty ? column : [Container()]),
      ),
    ),
  );
}


