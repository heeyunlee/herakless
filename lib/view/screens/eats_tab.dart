import 'package:flutter/material.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

class EatsTab extends StatefulWidget {
  const EatsTab({Key? key}) : super(key: key);

  @override
  _EatsTabTabState createState() => _EatsTabTabState();
}

class _EatsTabTabState extends State<EatsTab> {
  @override
  Widget build(BuildContext context) {
    logger.d('[EatsTab] building...');

    return const Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeColors.bottomNavBar,
      body: EatsTabBodyWidget(),
    );
  }
}
