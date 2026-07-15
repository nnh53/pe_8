import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

/// The root campus equipment-loan application.
final class CampusEquipmentLoanApp extends StatelessWidget {
  /// Creates the root application widget.
  const CampusEquipmentLoanApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Campus Equipment Loan',
    debugShowCheckedModeBanner: false,
    theme: buildLightTheme(),
    routerConfig: appRouter,
  );
}
