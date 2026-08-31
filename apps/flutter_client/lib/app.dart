import 'package:flutter/material.dart';

import 'ui/app_view_model.dart';
import 'ui/auth/auth_view.dart';
import 'ui/home/home_view.dart';

class CampusMeowApp extends StatelessWidget {
  const CampusMeowApp({required this.viewModel, super.key});
  final AppViewModel viewModel;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CampusMeow',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006c51)),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => viewModel.authenticated
          ? HomeView(viewModel: viewModel)
          : AuthView(viewModel: viewModel),
    ),
  );
}
