import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:NotesApp/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoPageScaffold(
                      navigationBar: const CupertinoNavigationBar(
                        middle: Text('About NotesApp'),
                      ),
                      child: Column(
                        children: [
                          CupertinoButton(
                            child: const Text('GitHub'),
                            onPressed: () async {
                              Uri uri = Uri(
                                  scheme: 'https',
                                  host: 'github.com',
                                  path: 'tseli0s/NotesApp');
                              canLaunchUrl(uri).then((value) {
                                if (value) {
                                  launchUrl(uri);
                                }
                              });
                            },
                          ),
                          MaterialButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
