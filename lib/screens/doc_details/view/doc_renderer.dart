import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import '../../../base_view.dart';
import '../../../config/styles.dart';
import '../components/buildForm.dart';
import '../components/customToast.dart';
import '../viewmodel/docrenderer_viewmodel.dart';

class DocRenderer extends StatelessWidget {
  var doctype;
  DocRenderer({super.key, required this.doctype});
  @override
  Widget build(BuildContext context) {
    print('${doctype['reference_name']}');
    return BaseView<DocRendererViewmodel>(
      onModelReady: (model) {
        model.loadMetaAndData(doctype['doctype'], doctype['reference_name']);
      },
      onModelClose: (model) {
        model.selectedMetaIndex = 0;
      },
      builder: (context, model, _) {
        return model.docLoading
            ? Scaffold(
              appBar: AppBar(
                title: Text('${doctype['reference_name']}'),
                titleSpacing: 0,
              ),
              body: const Center(child: CircularProgressIndicator.adaptive()),
            )
            : DefaultTabController(
              length: model.modifiedMeta.length,
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    appBar: _buildAppBar(
                      model,
                      doctype['doctype'],
                      doctype['reference_name'],
                      context,
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(model),
                        model.currentMeta != null
                            ? Expanded(
                              child: buildForm(context, model, doctype),
                            )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    DocRendererViewmodel model,
    String doctypeName,
    String referenceName,
    BuildContext context,
  ) {
    return AppBar(
      title: Text(
        '${doctype['reference_name']}',
        style: TextStyle(fontSize: 18),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            model.loadMetaAndData(doctypeName, referenceName);
          },
        ),
        _buildDocSaver(context, model),
        const SizedBox(width: 10),
        _buildActionsButton(context, model),
        const SizedBox(width: 10),
      ],
    );
  }

  // Widget _buildHeader(BuildContext context, DocRendererViewmodel model) {
  //   return Row(
  //     children: [
  //       InkWell(
  //         onTap: () => Navigator.of(context).pop(),
  //         child: const Icon(Icons.arrow_back_ios_new),
  //       ),
  //       const SizedBox(width: 10),
  //       Text(
  //         '${doctype['reference_name']}',
  //         style: const TextStyle(fontSize: 22),
  //       ),
  //       const SizedBox(width: 10),
  //       _buildStatusTag(model),
  //       const Spacer(),
  //       _buildDocSaver(context, model),
  //       const SizedBox(width: 10),
  //       _buildActionsButton(context, model),
  //     ],
  //   );
  // }

  Widget _buildStatusTag(DocRendererViewmodel model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '${model.currentData['docs'].first['workflow_state']}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Widget _buildDocSaver(BuildContext context, DocRendererViewmodel model) {
  //   return InkWell(
  //     onTap: () {
  //       if (model.formKey.currentState!.validate()) {
  //         model.controllers.forEach((key, controller) {
  //           model.currentData['docs'].first[key] = controller.text;
  //         });
  //         model.editDoc(
  //           model.currentData['docs'].first,
  //           model.currentMeta['docs'].first['name'],
  //           model.currentData['docs'].first['name'],
  //         );
  //       }
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 32,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF68712),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Center(
  //         child: Text(
  //           "Save",
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDocSaver(BuildContext context, DocRendererViewmodel model) {
  //   return InkWell(
  //     onTap: () {
  //       bool hasError = false;
  //
  //       model.showValidationErrors = true;
  //
  //       model.currentMeta['docs'].first['fields'].forEach((field) {
  //         String fieldname = field['fieldname'];
  //         if (field['reqd'] == 1) {
  //           String value = model.controllers[fieldname]?.text ?? '';
  //           if (value.trim().isEmpty) {
  //             hasError = true;
  //           }
  //         }
  //       });
  //
  //       if (hasError) {
  //         // Show snackbar or alert
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Please fill all required fields.")),
  //         );
  //         return;
  //       }
  //
  //       // No validation errors, proceed
  //       model.controllers.forEach((key, controller) {
  //         model.currentData['docs'].first[key] = controller.text;
  //       });
  //
  //       model.editDoc(
  //         model.currentData['docs'].first,
  //         model.currentMeta['docs'].first['name'],
  //         model.currentData['docs'].first['name'],
  //       );
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 32,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF68712),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: const Center(
  //         child: Text(
  //           "Save",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDocSaver(BuildContext context, DocRendererViewmodel model) {
    return InkWell(
      onTap: () {
        // bool hasError = false;
        //
        // // Enable error mode
        // model.showValidationErrors = true;
        //
        // // Validate all required fields
        // model.currentMeta['docs'].first['fields'].forEach((field) {
        //   String fieldname = field['fieldname'];
        //   if (field['reqd'] == 1) {
        //     String value = model.controllers[fieldname]?.text ?? '';
        //     if (value.trim().isEmpty) {
        //       hasError = true;
        //     }
        //   }
        // });
        //
        // if (hasError) {
        //   // Show feedback
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   const SnackBar(content: Text("Please fill all required fields.")),
        //   // );
        //   showToast(
        //     context,
        //     "Please fill all required fields.",
        //     isSuccess: false,
        //   );
        //
        //   // Force UI to rebuild with error styles
        //   model.notifyListeners(); // or setState() if you're not using ViewModel
        //   return;
        // }

        // Validation passed, collect values
        model.controllers.forEach((key, controller) {
          String text = controller.text.trim();

          bool looksLikeFloat(String s) {
            // we are doing this to check if string follows float pattern
            final floatRegex = RegExp(r'^-?\d+\.\d+$');
            return floatRegex.hasMatch(s);
          }

          if (looksLikeFloat(text)) {
            model.currentData['docs'].first[key] = double.parse(text);
          } else {
            model.currentData['docs'].first[key] = text;  // leave as string
          }
        });

        // Save document
        model.editDoc(
          model.currentData['docs'].first,
          model.currentMeta['docs'].first['name'],
          model.currentData['docs'].first['name'],
        );
        showToast(context, "Changes saved successfully", isSuccess: true);

        model.showValidationErrors = false; // Optional: reset error mode
      },
      child: Container(
        width: 100,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF68712),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void showToast(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (_) => Positioned(
            bottom: 20,
            right: 20,
            child: CustomToast(
              message: message,
              isSuccess: isSuccess,
              onClose: () {
                overlayEntry.remove();
              },
            ),
          ),
    );

    overlay.insert(overlayEntry);
  }

  Widget _buildActionsButton(BuildContext context, DocRendererViewmodel model) {
    return Container(
      width: 117,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF68712),
        borderRadius: BorderRadius.circular(10),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          model.applyWorkflowTransition(
            value,
            doctype['doctype'],
            doctype['reference_name'],
          );
          showToast(
            context,
            "Action applied successfully",
            isSuccess: true,
          ); // Optional
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Actions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
        itemBuilder:
            (BuildContext context) => [
              ...List.generate(model.workflowState.length, (index) {
                return PopupMenuItem<String>(
                  value: '${model.workflowState[index]['action']}',
                  child: Text('${model.workflowState[index]['action']}'),
                );
              }),
            ],
      ),
    );
  }

  Widget _buildTabBar(DocRendererViewmodel model) {
    return TabBar(
      isScrollable: true,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFFF68712), width: 5),
        insets: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      labelColor: const Color(0xFFF68712),
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      tabs: model.modifiedMeta.keys.map((key) => Tab(text: key)).toList(),
      onTap: (index) => model.changeMetaIndex(index),
    );
  }
}
