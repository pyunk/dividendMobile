// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dividend Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _pageTitles = ['Dividend Calculator', 'About'];

  // List of pages to display based on drawer selection
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AboutPage(),
  ];

  // Handles drawer item tap and navigation
  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    // Define colors for drawer items for clarity
    final Color unselectedItemColor = Colors.grey.shade700;
    final Color selectedItemColor = Colors.blue.shade700; // For selected item text and icon

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                // Use AppBar's background color for DrawerHeader consistency
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0), // Adjust padding if needed
                  child: Text(
                    'Menu',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded( // Ensures ListView takes remaining space
              child: Container(
                color: Colors.white, // Sets background for the list item area
                child: ListView(
                  padding: EdgeInsets.zero, // Remove default padding from ListView
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                        Icons.calculate,
                        color: _selectedIndex == 0 ? selectedItemColor : unselectedItemColor,
                      ),
                      title: Text(
                        'Calculator',
                        style: TextStyle(
                          color: _selectedIndex == 0 ? selectedItemColor : unselectedItemColor,
                          fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      tileColor: null, // Inherits white from parent Container
                      selected: _selectedIndex == 0,
                      onTap: () {
                        _onDrawerItemTapped(0);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                        Icons.info_outline,
                        color: _selectedIndex == 1 ? selectedItemColor : unselectedItemColor,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(
                          color: _selectedIndex == 1 ? selectedItemColor : unselectedItemColor,
                          fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      tileColor: null, // Inherits white from parent Container
                      selected: _selectedIndex == 1,
                      onTap: () {
                        _onDrawerItemTapped(1);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}