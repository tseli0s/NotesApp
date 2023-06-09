import 'package:NotesApp/text_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:NotesApp/header.dart';
import 'package:NotesApp/settings.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff1971ff),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF00A6FF),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xffff4f55),
    onError: Color(0xffff0009),
    background: Colors.black87,
    onBackground: Colors.black12,
    surface: Color(0xFF488EFF),
    onSurface: Color(0xffffffff),
  ),
  scaffoldBackgroundColor: const Color(0xFF131313),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF131313),
  ),
);

void main() async {
  runApp(const MaterialApp(home: NotesApp()));
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  NotesAppState createState() => NotesAppState();
}

class NotesAppState extends State<NotesApp> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (_currentIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final futureNotes = loadNotes(context);

    return MaterialApp(
      title: 'NotesApp',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: darkTheme,
      home: Scaffold(
        body: FutureBuilder<List<Widget>>(
          future: futureNotes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading notes'),
              );
            } else {
              final widgets = snapshot.data ?? [];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 128,
                    ),
                    Header('Welcome!', Colors.black),
                    const Text('Choose a note below, or create one.'),
                    const SizedBox(
                      height: 24,
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      clipBehavior: Clip.antiAlias,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: widgets,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      autofocus: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TextEditor(
                              title: '',
                              body: '',
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Text('New note...'),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              label: 'App Settings',
              icon: Icon(Icons.settings_applications),
            ),
            BottomNavigationBarItem(
              label: 'Refresh Notes',
              icon: Icon(Icons.refresh_rounded),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<Widget>> loadNotes(BuildContext context) async {
  final appDirectory = await getApplicationDocumentsDirectory();

  final noteFiles = appDirectory.listSync();

  final notes = <Widget>[];

  for (final file in noteFiles) {
    if (file is File && file.path.endsWith('.nte')) {
      final filename = file.path.split('/').last;
      final title = filename.substring(
          0, filename.length - 4); // Removing the .nte extension

      final contents = await file.readAsString();

      if (context.mounted) {
        final note = createNoteCell(context, title, contents);
        notes.add(note);
      } else {
        if (kDebugMode) print('Context isn\'t mounted, not adding cell.');
      }
    }
  }

  return notes;
}

void removeNoteFile(BuildContext context, String title) async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final noteFilePath = '${appDirectory.path}/$title.nte';
  final noteFile = File(noteFilePath);

  if (await noteFile.exists()) {
    await noteFile.delete();
    if (context.mounted) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Note deleted"),
            content: Text("The note '$title' has been deleted succesfully."),
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
  } else {
    if (context.mounted) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Couldn't remove note '$title'!"),
            content: const Text(
                "There was an error while attempting to remove the file containing the note. Try again later."),
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
  }
}

Widget createNoteCell(BuildContext context, String title, String body) {
  return CupertinoContextMenu(
    actions: [
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TextEditor(title: title, body: body),
            ),
          );
        },
        isDefaultAction: true,
        isDestructiveAction: false,
        trailingIcon: CupertinoIcons.folder_open,
        child: const Text('Edit Note'),
      ),
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.pop(context);
          removeNoteFile(context, title);
        },
        isDestructiveAction: true,
        trailingIcon: CupertinoIcons.delete,
        child: const Text('Delete Note'),
      ),
    ],
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 32.0, maxHeight: 32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => TextEditor(
                title: title,
                body: body,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue[700]!, Colors.blue[800]!],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
