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
                backgroundColor: Colors.white,
                title: Text('${doctype['reference_name']}',style: TextStyle(color: Colors.black),),
                titleSpacing: 0,
                iconTheme: IconThemeData(color: Colors.black),
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
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        '${doctype['reference_name']}',
        style: TextStyle(fontSize: 18,color: Colors.black),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh,color: Colors.black,),
          onPressed: () {
            model.loadMetaAndData(doctypeName, referenceName);
          },
        ),
        model.workflowState.isNotEmpty ?
        _buildDocSaver(context, model) : Container(),
        const SizedBox(width: 10),
        model.workflowState.isNotEmpty ?
        _buildActionsButton(context, model) : Container(),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildDocSaver(BuildContext context, DocRendererViewmodel model) {
    return InkWell(
      onTap: () {

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
          color: const Color(0xFF006CB5),
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
        color: const Color(0xFF006CB5),
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
        borderSide: BorderSide(color: Color(0xFF006CB5), width: 5),
        insets: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      labelColor: const Color(0xFF006CB5),
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      tabs: model.modifiedMeta.keys.map((key) => Tab(text: key)).toList(),
      onTap: (index) => model.changeMetaIndex(index),
    );
  }
}
