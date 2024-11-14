// lib/main.dart

import 'package:fish_news_app/fishing/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fish_news_app/fishing/view_models/vessel_view_model.dart';
import 'package:fish_news_app/fishing/view_models/fishing_event_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        // Provide VesselViewModel
        ChangeNotifierProvider<VesselViewModel>(
          create: (BuildContext context) => VesselViewModel(),
        ),
        // Provide FishingEventViewModel
        ChangeNotifierProvider<FishingEventViewModel>(
          create: (BuildContext context) => FishingEventViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fish News App',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        brightness: Brightness.light, // Set the light theme
        primarySwatch: Colors.blue,
        // You can customize other theme properties here
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Set the dark theme
        primarySwatch: Colors.blueGrey,
        // Customize dark theme properties
      ),
      themeMode: ThemeMode.system, // Use system setting to determine theme
      home: const HomeScreen(),
    );
  }
}
