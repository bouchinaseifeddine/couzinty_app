import 'package:couzinty/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundGreen,
      body: SplashViewBody(),
    );
  }
}
