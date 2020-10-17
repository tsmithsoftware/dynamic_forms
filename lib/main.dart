import 'package:dynamic_forms/features/dynamic_form_load/presentation/pages/dynamic_checks_page.dart';
import 'package:flutter/material.dart';
import 'base_injection_container.dart' as di;

void main() async {
  // Binding should be initialized before any method is called
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Checks Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DynamicChecksPage()
    );
  }
}