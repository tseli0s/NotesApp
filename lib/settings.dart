import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:NotesApp/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

void showCupertinoAboutDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData.light(useMaterial3: true),
        child: CupertinoAlertDialog(
          title: const Text('About NotesApp'),
          content: Column(
            children: [
              const Text('A minimal and open source note taking application.'),
              const SizedBox(height: 24),
              CupertinoButton(
                child: const Text('Source Code'),
                onPressed: () {
                  final githubUrl = Uri(
                    scheme: 'https',
                    host: 'github.com',
                    path: 'tselios/NotesApp',
                  );
                  launchUrl(githubUrl);
                },
              ),
              const Text('Version: 0.1.0'),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GradientButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => Navigator.pop(context),
              gradientColors: const [
                Colors.blue,
                Colors.blueAccent,
              ],
              iconGradientColors: const [
                Colors.white,
                Colors.white70,
              ],
            ),
            ListTile(
              title: const Text('Accent Color'),
              subtitle: const Text('Select the accent color for the app'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('About'),
              subtitle: const Text('View information about the app'),
              onTap: () {
                showCupertinoAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
