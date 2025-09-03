import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileViewer extends StatelessWidget {
  final String fileUrl;
  const FileViewer({super.key, required this.fileUrl});

  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String fileName = fileUrl.split('/').last;
    String fileExtension = fileUrl.split('.').last.toLowerCase();
    return ListTile(
      title: Text(fileName, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[300],decoration: TextDecoration.underline),),
      leading: Icon(Icons.insert_drive_file,color: Colors.blue[300]),
      onTap: () {
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(fileExtension)) {
          _showImagePopup(context, fileUrl);
        } else {
          launchUrl(Uri.parse(fileUrl));
        }
      },
    );
  }
}