import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/BusinessLogic/Provider/BusinessDetailProvider/business_detail_provider.dart';
import 'package:technical_test/BusinessLogic/Provider/BusinessProvider/business_provider.dart';
import 'package:technical_test/core/app_theme.dart';

import 'Src/View/into_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => BusinessDetailProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const IntroScreen(),
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
