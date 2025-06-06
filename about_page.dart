// lib/pages/about_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For GitHub icon

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Utility function to launch a URL in an external application.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Throws an error if the URL cannot be launched.
      throw 'Could not launch $urlString';
    }
  }

  // Reusable widget to build a ListTile for displaying information with an icon.
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor, // The color for the leading icon.
    required BuildContext context, // Context is passed, though not directly used in this specific version of the helper.
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: iconColor), // Displays the icon with the specified color.
      title: Text(
        title,
        style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the application's current theme.

    // Define a specific shade of blue for prominent text elements.
    final Color prominentBlue = Colors.blue[700]!;

    return Scaffold( // Main structure for the About page. AppBar is handled by MainScreen.
      body: SingleChildScrollView( // Allows the page content to be scrollable.
        padding: const EdgeInsets.all(20.0), // Overall padding for the page content.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center-aligns items like the app icon.
          children: <Widget>[
            // Section for displaying the App Icon.
            SizedBox(
              width: 120,
              height: 120,
              child: Card(
                elevation: 6,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias, // Ensures the child Image respects the Card's rounded corners.
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/img/gold.png', // Path to the app's icon.
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback widget if the image asset fails to load.
                      return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // App Name display.
            Text(
              'Dividend Calculator App',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: prominentBlue, // Uses the defined prominent blue.
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // App tagline or short description.
            Text(
              'Your trusted tool for unit trust investment calculations.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Card containing Author Information.
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns content within the card to the start.
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
                      // Title for the Author Information section.
                      child: Text(
                        'Author Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: prominentBlue, // Uses prominent blue.
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(indent: 16, endIndent: 16, thickness: 0.8), // Visual separator.
                    // Displaying author details using the _buildInfoTile helper.
                    _buildInfoTile(
                      context: context,
                      icon: Icons.person_outline_rounded,
                      title: 'Name',
                      subtitle: 'Muhammad Sufyan Bin Syarifulnizam', // <<-- REPLACE with actual name
                      iconColor: prominentBlue, // Uses prominent blue for the icon.
                    ),
                    _buildInfoTile(
                      context: context,
                      icon: Icons.confirmation_number_outlined,
                      title: 'Matric No',
                      subtitle: '2023197675', // <<-- REPLACE with actual matric number
                      iconColor: prominentBlue,
                    ),
                    _buildInfoTile(
                      context: context,
                      icon: Icons.school_outlined,
                      title: 'Course',
                      subtitle: 'NETCENTRIC', // <<-- REPLACE with actual course
                      iconColor: prominentBlue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Button to navigate to the GitHub repository.
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.github, size: 20), // GitHub icon.
              label: const Text('View on GitHub'),
              onPressed: () => _launchURL('https://github.com/pyunk'), // <<-- REPLACE with your GitHub URL
              // Styling for ElevatedButton is inherited from the global theme in main.dart.
            ),
            const SizedBox(height: 40),

            // Copyright notice.
            Text(
              'Copyright © ${DateTime.now().year} Sufyan Syarifulnizam', // <<-- REPLACE with your name
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Adds some padding at the bottom of the page.
          ],
        ),
      ),
    );
  }
}