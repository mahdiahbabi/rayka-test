// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:rayka_test/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initiolizedService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var defaultFontFamily = 'BHoma';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            titleLarge: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontFamily: defaultFontFamily, fontSize: 15),
            labelLarge: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold)),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                foregroundColor: MaterialStatePropertyAll(Colors.white))),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  Onboarding(),
    );
  }
}
