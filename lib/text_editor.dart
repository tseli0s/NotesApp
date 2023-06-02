// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TextEditor extends StatefulWidget {
  final String title;
  final String body;

  const TextEditor({super.key, required this.title, required this.body});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    bodyController.text = widget.body;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<bool> saveNoteToFile(String title, String body) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final file = await File('${appDirectory.path}/$title.nte').create();

      await file.writeAsString(body);
      return true;
    } catch (e) {
      showDialog('Error while saving note', '$e');
      return false;
    }
  }

  void showDialog(String title, String msg) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              icon: const Icon(
                Icons.expand_more, // Customize the icon
                color: Colors.black,
              ),
              onSelected: (value) async {
                if (value == 'close') {
                  Navigator.pop(context);
                } else if (value == 'save') {
                  final title = titleController.text;
                  final body = bodyController.text;

                  saveNoteToFile(title, body).then(
                    (value) => showDialog(
                      'Saved note to disk',
                      'Note $title has been saved',
                    ),
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'close',
                  child: Text('Close current'),
                ),
                PopupMenuItem(
                  value: 'save',
                  child: Text('Save'),
                ),
              ],
            ),
            TextField(
              controller: titleController,
              maxLength: 100,
              decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none),
              style: const TextStyle(
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              style: const TextStyle(
                fontSize: 28,
              ),
              controller: bodyController,
              maxLines: null,
              decoration: const InputDecoration(
                  labelText: 'Body', border: InputBorder.none),
            ),
            const SizedBox(height: 16.0)
          ],
        ),
      ),
    );
  }
}
