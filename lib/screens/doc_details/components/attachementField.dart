import 'dart:io';
import 'package:community/utils/Urls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../web_requests/web_requests.dart';
import 'fileViewer.dart';

class AttachmentHandler extends StatefulWidget {
  final Map<String, dynamic> doctype;

  const AttachmentHandler({super.key, required this.doctype});

  @override
  _AttachmentHandlerState createState() => _AttachmentHandlerState();
}

class _AttachmentHandlerState extends State<AttachmentHandler> {
  List<dynamic> attachedFiles = [];
  var rootUrl = '';

  @override
  void initState() {
    Urls().root().then((value) {
      rootUrl = value;
    });
    super.initState();
    fetchAttachments();
  }

  Future<void> fetchAttachments() async {
    var files = await WebRequests().getAttachedFiles(
      null,
      widget.doctype['reference_name'],
      widget.doctype['doctype'],
    );
    setState(() {
      attachedFiles = files ?? [];
    });
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files =
          result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

      int uploadedFiles = 0;

      for (File file in files) {
        int uploads = await WebRequests().uploadFiles(
          file: file,
          docName: widget.doctype['reference_name'],
          docType: widget.doctype['doctype'],
        );

        if (uploads > 0) {
          uploadedFiles++;
        }
      }

      if (uploadedFiles > 0) {
        fetchAttachments(); // Refresh UI after all uploads are done
      }
    } else {
      // print("No files selected");
    }
  }

  Future<void> confirmDeleteFile(String fid) async {
    bool? confirmDelete = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double dialogHeight = screenHeight * 0.25; // 25% of screen height

        return Align(
          alignment: Alignment.topCenter, // Keep dialog at the top center
          child: Padding(
            padding: const EdgeInsets.only(top: 50), // Adjust Top Margin
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 575,
                constraints: BoxConstraints(
                  maxHeight: dialogHeight, // Keep height flexible
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // White Background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  // Prevent overflow issues
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title + Close Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ],
                        ),

                        // Message
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 20),
                          child: Text(
                            "Are you sure you want to delete the attachment?",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "DM Sans",
                            ),
                          ),
                        ),

                        // Buttons (Aligned Bottom-Right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // No Button
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Colors.white, // White Background
                                side: const BorderSide(
                                  color: Color(0xFFF68712),
                                ), // Orange Border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(99, 32), // Button Size
                              ),
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xFFF68712), // Orange Text
                                ),
                              ),
                            ),

                            const SizedBox(width: 10), // Spacing
                            // Yes Button
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFF68712,
                                ), // Orange Background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(99, 32), // Button Size
                              ),
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white, // White Text
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (confirmDelete == true) {
      deleteFile(fid);
    }
  }

  Future<void> deleteFile(String fid) async {
    bool success = await WebRequests().deleteAttachements(
      fid: fid,
      docName: widget.doctype['reference_name'],
      docType: widget.doctype['doctype'],
    );
    if (success) {
      fetchAttachments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reference Documents'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: pickAndUploadFile,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF68712),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New File',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...attachedFiles.map((file) {
                return ListTile(
                  title: FileViewer(fileUrl: rootUrl + file['file_url']),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => confirmDeleteFile(file['name']),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildAttachementField(parent, context, doctype) {
  return AttachmentHandler(doctype: doctype);
}
